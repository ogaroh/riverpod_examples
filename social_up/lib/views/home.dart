import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_up/extensions/log.dart';
import 'package:social_up/state/auth/backend/authenticator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SocialUp",
        ),
      ),
      body: Column(
        children: [
          FilledButton.icon(
            onPressed: () async {
              final result = await Authenticator().loginWithGoogle();
              result.log();
            },
            icon: const Icon(
              FontAwesomeIcons.google,
            ),
            label: const Text("Sign In with Google"),
          ),
          FilledButton.icon(
            onPressed: () async {
              final result = await Authenticator().loginWithFacebook();
              result.log();
            },
            icon: const Icon(
              FontAwesomeIcons.facebookF,
            ),
            label: const Text("Sign In with Facebook"),
          ),
        ],
      ),
      floatingActionButton: const FloatingActionButton.extended(
        onPressed: null,
        label: Text("Post"),
        icon: Icon(Icons.add_a_photo_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
