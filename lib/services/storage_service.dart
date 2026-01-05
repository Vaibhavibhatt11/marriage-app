import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Upload profile photo
  Future<String> uploadProfileImage(
    String userId,
    XFile imageFile, {
    bool isMain = false,
  }) async {
    try {
      final fileName = isMain 
          ? 'profile_main_${DateTime.now().millisecondsSinceEpoch}'
          : 'profile_${DateTime.now().millisecondsSinceEpoch}';
      
      final ref = _storage.ref().child('users/$userId/profile/$fileName');
      final uploadTask = await ref.putData(
        await imageFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages(
    String userId,
    List<XFile> imageFiles,
  ) async {
    try {
      final List<String> urls = [];
      
      for (var imageFile in imageFiles) {
        final url = await uploadProfileImage(userId, imageFile);
        urls.add(url);
      }
      
      return urls;
    } catch (e) {
      rethrow;
    }
  }

  // Delete image
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }

  // Pick image from gallery
  Future<XFile?> pickImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      rethrow;
    }
  }

  // Pick multiple images
  Future<List<XFile>> pickMultipleImages() async {
    try {
      final images = await _picker.pickMultiImage(
        imageQuality: 85,
      );
      return images;
    } catch (e) {
      rethrow;
    }
  }
}