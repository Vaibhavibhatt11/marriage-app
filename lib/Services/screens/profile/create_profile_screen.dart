import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brahmin_marriage/models/profile_model.dart';
import 'package:brahmin_marriage/Services/database_service.dart';
import 'package:brahmin_marriage/Services/screens/home/home_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:brahmin_marriage/Services/services/storage_service.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController gotraController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  bool isSaving = false;
  bool isUploadingImage = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;
    setState(() {
      _selectedImage = File(picked.path);
    });
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final uid = FirebaseAuth.instance.currentUser?.uid ??
        DateTime.now().millisecondsSinceEpoch.toString();
    String imageUrl = imageUrlController.text.trim();
    if (_selectedImage != null) {
      setState(() => isUploadingImage = true);
      try {
        imageUrl = await StorageService().uploadImage(_selectedImage!, uid);
      } catch (e) {
        setState(() {
          isSaving = false;
          isUploadingImage = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Image upload failed: $e')));
        return;
      }
      setState(() => isUploadingImage = false);
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
    try {
      await DatabaseService().saveProfile(profile);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => const HomeScreen()),
      );
    } catch (e) {
      setState(() => isSaving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Profile')),
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
                      (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final a = int.tryParse(v ?? '');
                    if (a == null) return 'Enter valid age';
                    if (a < 18 || a > 70) {
                      return 'Age must be between 18 and 70';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: gotraController,
                  decoration: const InputDecoration(labelText: 'Gotra'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: educationController,
                  decoration: const InputDecoration(labelText: 'Education'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: professionController,
                  decoration: const InputDecoration(labelText: 'Profession'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter city' : null,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: pickImage,
                  child: _selectedImage != null
                      ? CircleAvatar(
                          radius: 48,
                          backgroundImage: FileImage(_selectedImage!),
                        )
                      : CircleAvatar(
                          radius: 48,
                          child: const Icon(Icons.camera_alt, size: 36),
                        ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Pick profile image'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        isSaving || isUploadingImage ? null : saveProfile,
                    child: isSaving || isUploadingImage
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
