import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pet_model.dart';
import '../features/providers/pet_providers.dart';
import '../../features/auth/providers/auth_providers.dart';

class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  // These "remember" what's typed in each text box
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();

  // This remembers which dropdown option is picked
  String _species = 'Dog';

  @override
  void dispose() {
    // Cleans up when the screen closes
    _nameController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  // Runs when "Save Pet" is tapped
  Future<void> _savePet() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return; // safety check — should never happen here

    final newPet = Pet(
      id: '', // Firestore will generate the real ID
      ownerId: user.uid,
      name: _nameController.text,
      species: _species,
      breed: _breedController.text,
    );

    await ref.read(petRepositoryProvider).addPet(newPet);

    if (mounted) {
      Navigator.of(context).pop(); // closes this screen, goes back
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a Pet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Pet name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _species,
              decoration: const InputDecoration(
                labelText: 'Species',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Dog', child: Text('Dog')),
                DropdownMenuItem(value: 'Cat', child: Text('Cat')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _species = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _breedController,
              decoration: const InputDecoration(
                labelText: 'Breed (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _savePet,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Save Pet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}