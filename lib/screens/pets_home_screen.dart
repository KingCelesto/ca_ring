import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/providers/pet_providers.dart';
import 'add_pet_screen.dart';

class PetsHomeScreen extends ConsumerWidget {
  const PetsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsListProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Pets')),
      body: petsAsync.when(
        data: (pets) {
          if (pets.isEmpty) {
            // Designed empty state: icon + heading + helper text
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets,
                    size: 80,
                    color: colors.primary.withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No pets yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Tap the + button below to add your first pet'),
                ],
              ),
            );
          }

          // Real pet list, styled as cards instead of plain rows
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: colors.primary.withOpacity(0.15),
                    child: Icon(
                      pet.species == 'Cat' ? Icons.cruelty_free : Icons.pets,
                      color: colors.primary,
                    ),
                  ),
                  title: Text(
                    pet.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${pet.species} • ${pet.breed}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddPetScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}