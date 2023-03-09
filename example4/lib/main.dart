import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      theme: ThemeData(primarySwatch: Colors.purple),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

// names
const names = [
  'Erick',
  'Obara',
  'Ogaro',
  'Eubert',
  'Nancy',
  'Lydiah',
  'Joseph',
  'Linet',
  'Jamie',
];

// ticker stream provider
final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(
      seconds: 1,
    ),
    (i) => i + 1,
  ),
);

// names provider TODO: 'stream' is deprecated and shouldn't be used. .stream
// will be removed in 3.0.0. As a replacement, either listen to the provider
// itself (AsyncValue) or .future.
// Try replacing the use of the deprecated member with the replacement.

final namesProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map(
        (count) => names.getRange(
          0,
          count,
        ),
      ),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("StreamProvider")),
      body: names.when(
        data: (names) {
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text(
                  names.elementAt(index),
                ),
              );
            }),
          );
        },
        error: (error, stackTrace) =>
            Center(child: Text("Error: ${error.toString()}")),
        loading: () => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}
