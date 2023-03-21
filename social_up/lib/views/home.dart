import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_up/state/auth/providers/auth_state_provider.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SocialUp",
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return Center(
            child: FilledButton.icon(
              onPressed: () async {
                // log out
                await ref.read(authStateProvider.notifier).logOut();
              },
              icon: const Icon(
                Icons.logout,
              ),
              label: const Text("Log Out"),
            ),
          );
        },
      ),
      // floatingActionButton: const FloatingActionButton.extended(
      //   onPressed: null,
      //   label: Text("Post"),
      //   icon: Icon(Icons.add_a_photo_outlined),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
