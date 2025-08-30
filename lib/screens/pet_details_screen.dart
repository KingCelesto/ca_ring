import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PetDetailsScreen extends StatefulWidget {
  final String petId;
  const PetDetailsScreen({super.key, required this.petId});

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  final name = TextEditingController();
  final breed = TextEditingController();
  final age = TextEditingController();
  String imageUrl = '';
  bool loading = true;
  bool updating = false;
  File? newImage;

  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('pets').doc(widget.petId).get();
    final data = doc.data()!;
    name.text = data['name'] ?? '';
    breed.text = data['breed'] ?? '';
    age.text = data['age'] ?? '';
    imageUrl = data['imageUrl'] ?? '';
    setState(() => loading = false);
  }

  Future<void> _pickNewImage() async {
    final res = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (res != null) setState(() => newImage = File(res.path));
  }

  Future<void> _update() async {
    setState(() => updating = true);
    try {
      final user = FirebaseAuth.instance.currentUser!;
      String finalUrl = imageUrl;

      if (newImage != null) {
        final ref = FirebaseStorage.instance.ref().child('pet_images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(newImage!);
        finalUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('pets').doc(widget.petId).update({
        'name': name.text.trim(),
        'breed': breed.text.trim(),
        'age': age.text.trim(),
        'imageUrl': finalUrl,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated')));
      Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => updating = false);
    }
  }

  Future<void> _delete() async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('pets').doc(widget.petId).delete();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Details'), actions: [
        IconButton(onPressed: _delete, icon: const Icon(Icons.delete), tooltip: 'Delete'),
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickNewImage,
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                  image: (newImage != null)
                      ? DecorationImage(image: FileImage(newImage!), fit: BoxFit.cover)
                      : (imageUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null),
                ),
                child: (newImage == null && imageUrl.isEmpty) ? const Icon(Icons.add_a_photo, size: 40) : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            TextField(controller: breed, decoration: const InputDecoration(labelText: 'Breed')),
            const SizedBox(height: 10),
            TextField(controller: age, decoration: const InputDecoration(labelText: 'Age')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: updating ? null : _update, child: updating ? const CircularProgressIndicator() : const Text('Update')),
          ],
        ),
      ),
    );
  }
}
