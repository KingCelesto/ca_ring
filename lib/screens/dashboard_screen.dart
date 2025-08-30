import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_pet_screen.dart';
import 'pet_details_screen.dart';
import 'reminders_screen.dart';
import '../models/pet_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final petsRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('pets').orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
        actions: [
          IconButton(
            tooltip: 'Reminders',
            icon: const Icon(Icons.alarm),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RemindersScreen())),
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: petsRef.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('No pets yet. Tap + to add one.'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              final pet = Pet.fromMap(d.id, d.data() as Map<String, dynamic>);
              return ListTile(
                leading: (pet.imageUrl?.isNotEmpty ?? false)
                    ? CircleAvatar(backgroundImage: NetworkImage(pet.imageUrl!))
                    : const CircleAvatar(child: Icon(Icons.pets)),
                title: Text(pet.name),
                subtitle: Text('Breed: ${pet.breed} • Age: ${pet.age}'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PetDetailsScreen(petId: pet.id))),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPetScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
