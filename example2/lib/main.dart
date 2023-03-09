import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// operator extension on `+`
extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

// counter state notifier
class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() => state = state == null ? 1 : state + 1;
  // int? get value => state;
}

// counter provider
final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter(),
);

// my app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Test',
      theme: ThemeData(primarySwatch: Colors.purple),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);
            final data = count == null ? 'Press the button' : count.toString();
            return Text(data);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton(
            onPressed: ref.read(counterProvider.notifier).increment,
            child: const Text("Increment"),
          ),
        ],
      ),
    );
  }
}
