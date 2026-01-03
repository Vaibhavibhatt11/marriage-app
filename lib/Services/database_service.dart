import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brahmin_marriage/models/profile_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveProfile(ProfileModel profile) async {
    await _db.collection('profiles').doc(profile.uid).set(profile.toMap());
  }

  Stream<List<ProfileModel>> getProfiles() {
    return _db.collection('profiles').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProfileModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<ProfileModel?> getProfileByUid(String uid) async {
    final doc = await _db.collection('profiles').doc(uid).get();
    if (!doc.exists) return null;
    return ProfileModel.fromMap(doc.data()!);
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await _db.collection('profiles').doc(profile.uid).update(profile.toMap());
  }

  Future<void> likeProfile(String fromUid, String toUid) async {
    final key = '${fromUid}_$toUid';
    await _db.collection('likes').doc(key).set({
      'from': fromUid,
      'to': toUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unlikeProfile(String fromUid, String toUid) async {
    final key = '${fromUid}_$toUid';
    await _db.collection('likes').doc(key).delete();
  }

  Stream<List<String>> getLikesByUser(String uid) {
    return _db
        .collection('likes')
        .where('from', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d['to'] as String).toList());
  }
}
