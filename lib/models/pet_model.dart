class Pet {
  final String id;
  final String name;
  final String breed;
  final String age;
  final String? imageUrl;

  Pet({required this.id, required this.name, required this.breed, required this.age, this.imageUrl});

  factory Pet.fromMap(String id, Map<String, dynamic> map) {
    return Pet(
      id: id,
      name: map['name'] ?? '',
      breed: map['breed'] ?? '',
      age: map['age'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'breed': breed,
        'age': age,
        'imageUrl': imageUrl ?? '',
      };
}
