import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E4374),
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: const Color(0xFF2E4374),
      ),
      body: const Center(
        child: Text(
          "This is Search Page 🔍",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
