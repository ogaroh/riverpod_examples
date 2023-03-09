import 'dart:collection';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

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
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({
    required this.name,
    required this.age,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Person updated([String? name, int? age]) => Person(
        name: name ?? this.name,
        age: age ?? this.age,
        uuid: uuid,
      );

  String get displayName => '$name ($age years old)';

  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => 'Person(name: $name, age: $age, uuid: $uuid)';
}

// data model
class DataModel extends ChangeNotifier {
  final List<Person> _people = [];

  int get count => _people.length;

  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);

  // add person to list
  void add(Person person) {
    _people.add(person);
    notifyListeners();
  }

  // remove person from list
  void remove(Person person) {
    _people.remove(person);
    notifyListeners();
  }

  // update
  void update(Person updatedPerson) {
    final index = _people.indexOf(updatedPerson);
    final previousPerson = _people[index];

    if (previousPerson.name != updatedPerson.name ||
        previousPerson.age != updatedPerson.age) {
      // update person details
      _people[index] = previousPerson.updated(
        updatedPerson.name,
        updatedPerson.age,
      );
      notifyListeners();
    }
  }
}

// people provider
final peopleProvder = ChangeNotifierProvider(
  (_) => DataModel(),
);

// home page
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Consumer(
        builder: (context, ref, child) {
          final dataModel = ref.watch(peopleProvder);
          return ListView.builder(
            itemCount: dataModel.count,
            itemBuilder: (context, index) {
              final person = dataModel.people[index];
              return ListTile(
                title: InkWell(
                  onTap: () async {
                    final updatedPerson = await createOrUpdatePersonDialog(
                      context,
                      person,
                    );

                    if (updatedPerson != null) {
                      dataModel.update(updatedPerson);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Text(
                      person.displayName,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final person = await createOrUpdatePersonDialog(
            context,
          );

          if (person != null) {
            final dataModel = ref.read(peopleProvder);
            dataModel.add(person);
          }
        },
        label: const Text("Create Person"),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

final nameController = TextEditingController();
final ageController = TextEditingController();

Future<Person?> createOrUpdatePersonDialog(
  BuildContext context, [
  Person? existingPerson,
]) {
  String? name = existingPerson?.name;
  int? age = existingPerson?.age;

  nameController.text = name ?? '';
  ageController.text = age?.toString() ?? '';

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(Icons.person_outline),
          title: Center(
              child: Text(
                  "${existingPerson == null ? 'Create' : 'Update'} Person")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Enter Name'),
                onChanged: (value) => name = value,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Enter Age'),
                onChanged: (value) => age = int.tryParse(value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                if (name != null && age != null) {
                  // update person
                  if (existingPerson != null) {
                    final newPerson = existingPerson.updated(
                      name,
                      age,
                    );
                    Navigator.of(context).pop(newPerson);
                  } else {
                    // create person
                    Navigator.of(context).pop(
                      Person(
                        name: name!,
                        age: age!,
                      ),
                    );
                  }
                } else {
                  // no name, age or both
                  Navigator.of(context).pop();
                }
              },
              label: Text(existingPerson == null ? 'Create' : 'Update'),
              icon: const Icon(Icons.save_alt),
            ),
          ],
        );
      });
}

// theme options
final kDefaultFontFamily = GoogleFonts.notoSans().fontFamily;

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
