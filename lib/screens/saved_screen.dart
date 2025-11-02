import 'package:flutter/material.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E4374),
      appBar: AppBar(
        title: const Text("Saved Articles"),
        backgroundColor: const Color(0xFF2E4374),
      ),
      body: const Center(
        child: Text(
          "Your saved news will appear here 📚",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
