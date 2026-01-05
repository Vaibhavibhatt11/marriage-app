import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brahmin_matrimony/models/user_model.dart';
import 'package:brahmin_matrimony/services/firestore_service.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userProfileProvider =
    FutureProviderFamily<UserModel?, String>((ref, uid) async {
  final service = ref.watch(firestoreServiceProvider);
  return await service.getUserProfile(uid);
});

final currentUserProfileProvider = FutureProvider<UserModel?>((ref) async {
  final auth = ref.watch(authStateProvider);
  final user = auth.value;

  if (user != null) {
    final service = ref.watch(firestoreServiceProvider);
    return await service.getUserProfile(user.uid);
  }
  return null;
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});
