import 'package:flutter/material.dart';

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
      floatingActionButton: const FloatingActionButton.extended(
        onPressed: null,
        label: Text("Post"),
        icon: Icon(Icons.add_a_photo_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
