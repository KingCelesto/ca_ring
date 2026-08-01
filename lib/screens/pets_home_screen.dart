import 'package:flutter/material.dart';

class PetsHomeScreen extends StatelessWidget {
  const PetsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
      ),
      body: const Center(
        child: Text('No pets yet — add your first one!'),
      ),
    );
  }
}