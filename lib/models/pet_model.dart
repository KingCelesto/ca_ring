class Pet {
  final String id;       // Firestore's document ID
  final String ownerId;  // which user this pet belongs to
  final String name;
  final String species;
  final String breed;

  Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    required this.breed,
  });

  // Converts a Pet into a plain Map, which is the format Firestore stores
  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'species': species,
      'breed': breed,
    };
  }

  // Converts data coming back FROM Firestore into a Pet object
  factory Pet.fromMap(String id, Map<String, dynamic> map) {
    return Pet(
      id: id,
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      species: map['species'] ?? '',
      breed: map['breed'] ?? '',
    );
  }
}