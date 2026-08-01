import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';

class PetRepository {
  final FirebaseFirestore _db;
  PetRepository(this._db);

  // A "reference" to the pets collection — doesn't fetch anything yet,
  // just points at where the data lives.
  CollectionReference get _petsRef => _db.collection('pets');

  // Watches all pets belonging to one user, live.
  Stream<List<Pet>> watchPets(String ownerId) {
    return _petsRef
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Pet.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> addPet(Pet pet) async {
    await _petsRef.add(pet.toMap());
  }
}