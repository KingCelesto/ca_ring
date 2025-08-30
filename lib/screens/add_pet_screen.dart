import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final name = TextEditingController();
  final breed = TextEditingController();
  final age = TextEditingController();
  File? imageFile;
  bool saving = false;

  Future<void> _pickImage() async {
    final res = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (res != null) setState(() => imageFile = File(res.path));
  }

  Future<void> _save() async {
    if (name.text.trim().isEmpty) return;
    setState(() => saving = true);
    try {
      final user = FirebaseAuth.instance.currentUser!;
      String imageUrl = '';
      if (imageFile != null) {
        final ref = FirebaseStorage.instance.ref().child('pet_images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
      }
      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('pets').add({
        'name': name.text.trim(),
        'breed': breed.text.trim(),
        'age': age.text.trim(),
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                  image: imageFile != null ? DecorationImage(image: FileImage(imageFile!), fit: BoxFit.cover) : null,
                ),
                child: imageFile == null ? const Icon(Icons.add_a_photo, size: 40) : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Pet Name')),
            const SizedBox(height: 10),
            TextField(controller: breed, decoration: const InputDecoration(labelText: 'Breed')),
            const SizedBox(height: 10),
            TextField(controller: age, decoration: const InputDecoration(labelText: 'Age')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saving ? null : _save,
              child: saving ? const CircularProgressIndicator() : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
