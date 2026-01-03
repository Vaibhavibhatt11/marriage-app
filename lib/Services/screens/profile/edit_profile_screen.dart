import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brahmin_marriage/models/profile_model.dart';
import 'package:brahmin_marriage/Services/database_service.dart';
import 'package:brahmin_marriage/Services/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController gotraController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  File? _image;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final p = await _db.getProfileByUid(uid);
    if (p != null) {
      nameController.text = p.name;
      ageController.text = p.age.toString();
      gotraController.text = p.gotra;
      educationController.text = p.education;
      professionController.text = p.profession;
      cityController.text = p.city;
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;
    setState(() => _image = File(picked.path));
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    final uid = FirebaseAuth.instance.currentUser?.uid ??
        DateTime.now().millisecondsSinceEpoch.toString();
    String imageUrl = '';
    if (_image != null) {
      imageUrl = await StorageService().uploadImage(_image!, uid);
    }
    final profile = ProfileModel(
      uid: uid,
      name: nameController.text.trim(),
      age: int.tryParse(ageController.text.trim()) ?? 0,
      gotra: gotraController.text.trim(),
      education: educationController.text.trim(),
      profession: professionController.text.trim(),
      city: cityController.text.trim(),
      imageUrl: imageUrl,
    );
    await _db.saveProfile(profile);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter name' : null),
                const SizedBox(height: 10),
                TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                TextFormField(
                    controller: gotraController,
                    decoration: const InputDecoration(labelText: 'Gotra')),
                const SizedBox(height: 10),
                TextFormField(
                    controller: educationController,
                    decoration: const InputDecoration(labelText: 'Education')),
                const SizedBox(height: 10),
                TextFormField(
                    controller: professionController,
                    decoration: const InputDecoration(labelText: 'Profession')),
                const SizedBox(height: 10),
                TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(labelText: 'City')),
                const SizedBox(height: 10),
                TextButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.upload),
                    label: const Text('Change Image')),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: save, child: const Text('Save'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
