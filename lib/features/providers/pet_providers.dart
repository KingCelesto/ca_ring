import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../repository/pet_repository.dart';
import '../../models/pet_model.dart';
import '../auth/providers/auth_providers.dart';

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return PetRepository(FirebaseFirestore.instance);
});

final petsListProvider = StreamProvider<List<Pet>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]); // no one logged in yet
  return ref.watch(petRepositoryProvider).watchPets(user.uid);
});