// login view
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_up/state/auth/providers/auth_state_provider.dart';

// for when you're not logged in
class LoginView extends ConsumerWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
              icon: const Icon(
                FontAwesomeIcons.google,
              ),
              label: const Text("Sign In with Google"),
            ),
            FilledButton.icon(
              onPressed: ref.read(authStateProvider.notifier).loginWithFacebook,
              icon: const Icon(
                FontAwesomeIcons.facebookF,
              ),
              label: const Text("Sign In with Facebook"),
            ),
          ],
        ),
      ),
    );
  }
}
