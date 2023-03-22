import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_up/state/auth/providers/auth_state_provider.dart';
import 'package:social_up/views/components/login/facebook_btn.dart';
import 'package:social_up/views/components/login/google_btn.dart';
import 'package:social_up/views/components/login/login_sign_up_links.dart';
import 'package:social_up/views/constants/app_colors.dart';
import 'package:social_up/views/constants/strings.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.appName,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              Text(
                Strings.welcomeToAppName,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Divider(
                height: 40.0,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                thickness: 0.5,
              ),
              Text(
                Strings.logIntoYourAccount,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                onPressed:
                    ref.read(authStateProvider.notifier).loginWithFacebook,
                child: const FacebookBtn(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
                child: const GoogleBtn(),
              ),
              Divider(
                height: 40.0,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                thickness: 0.5,
              ),
              const LoginViewSignupLinks(),
            ],
          ),
        ),
      ),
    );
  }
}
