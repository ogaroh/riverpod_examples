import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// hardcoded films
const allFilms = [
  Film(
    id: '1',
    title: 'The Godfather',
    description: 'Description for The Godfather',
    isFavorite: false,
  ),
  Film(
    id: '2',
    title: 'The Godfather: Part II',
    description: 'Description for The Godfather: Part II',
    isFavorite: false,
  ),
  Film(
    id: '3',
    title: 'Shawshank Redemption',
    description: 'Description for Shawshank Redemption',
    isFavorite: false,
  ),
  Film(
    id: '4',
    title: 'The Dark Knight',
    description: 'Description for The Dark Knight',
    isFavorite: false,
  ),
];

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allFilms);

  // update film
  void update(Film film, bool isFavorite) {
    state = state
        .map((thisFilm) => thisFilm.id == film.id
            ? thisFilm.copy(isFavorite: isFavorite)
            : thisFilm)
        .toList();
  }
}

// favorite statuses
enum FavoriteStatus {
  all,
  favorite,
  notFavorite,
}

// favorite status provider
final favoriteStatusProvider =
    StateProvider<FavoriteStatus>((_) => FavoriteStatus.all);

// all films provider
final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>(
  (_) => FilmsNotifier(),
);

// favorite films
final favoriteFilmsProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => film.isFavorite,
      ),
);

// not-favorite films
final notFavoriteFilmsProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => !film.isFavorite,
      ),
);

// my app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Test',
      theme: flexLight,
      darkTheme: flexDark,
      // themeMode: ThemeMode.system,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });

  Film copy({
    required bool isFavorite,
  }) =>
      Film(
        id: id,
        title: title,
        description: description,
        isFavorite: isFavorite,
      );

  @override
  String toString() => 'Film(id: $id,'
      'title: $title,'
      'description: $description,'
      'isFavorite: $isFavorite)';

  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavorite == other.isFavorite;

  @override
  int get hashCode => Object.hashAll(
        [
          id,
          isFavorite,
        ],
      );
}

// home page
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Films")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FilterWidget(),
            Consumer(
              builder: (context, ref, child) {
                final filter = ref.watch(favoriteStatusProvider);
                switch (filter) {
                  case FavoriteStatus.all:
                    return FilmsList(provider: allFilmsProvider);
                  case FavoriteStatus.favorite:
                    return FilmsList(provider: favoriteFilmsProvider);
                  case FavoriteStatus.notFavorite:
                    return FilmsList(provider: notFavoriteFilmsProvider);
                  default:
                    return FilmsList(provider: allFilmsProvider);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// films widget
class FilmsList extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsList({
    required this.provider,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films.elementAt(index);
          final favoriteIcon = film.isFavorite
              ? Icon(
                  Icons.favorite,
                  color: Colors.red.shade600,
                )
              : const Icon(
                  Icons.favorite_border,
                );

          return ListTile(
            title: Text(
              film.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              film.description,
            ),
            trailing: IconButton(
              icon: favoriteIcon,
              onPressed: () {
                final isFavorite = !film.isFavorite;
                ref.read(allFilmsProvider.notifier).update(film, isFavorite);
              },
            ),
          );
        },
      ),
    );
  }
}

// filter widget
class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: DropdownButton(
            isExpanded: true,
            value: ref.watch(favoriteStatusProvider),
            items: FavoriteStatus.values
                .map(
                  (fs) => DropdownMenuItem(
                    value: fs,
                    child: Text(
                      fs.toString().toUpperCase().split('.').last,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                )
                .toList(),
            onChanged: (fs) {
              ref
                  .read(
                    favoriteStatusProvider.notifier,
                  )
                  .state = fs!;
            },
          ),
        );
      },
    );
  }
}

// theme options
final kDefaultFontFamily = GoogleFonts.notoSansAdlam().fontFamily;

final flexLight = FlexThemeData.light(
  scheme: FlexScheme.deepBlue,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    blendOnColors: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  fontFamily: kDefaultFontFamily,
);

final flexDark = FlexThemeData.dark(
  scheme: FlexScheme.aquaBlue,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  fontFamily: kDefaultFontFamily,
);
