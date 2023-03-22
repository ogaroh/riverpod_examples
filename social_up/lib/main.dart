import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_up/state/auth/providers/is_logged_in_provider.dart';
import 'package:social_up/state/providers/is_loading_provider.dart';
import 'package:social_up/views/components/loading/loading_screen.dart';
import 'firebase_options.dart';
import 'theme/theme.dart';
import 'views/home.dart';
import 'views/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      title: 'SocialUp',
      theme: flexLight,
      darkTheme: flexDark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: (context, ref, child) {
          // take care of showing the loading screen
          ref.listen<bool>(
            isLoadingProvider,
            (_, isLoading) {
              if (isLoading) {
                LoadingScreen.instance().show(
                  context: context,
                  text: "Please wait...",
                );
              } else {
                LoadingScreen.instance().hide();
              }
            },
          );

          // check if user is logged in
          final isLoggedIn = ref.watch(isLoggedInProvider);

          if (isLoggedIn) {
            return const MainView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}
