import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brahmin_matrimony/models/user_model.dart';
import 'package:brahmin_matrimony/models/match_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get matchRequestsCollection => 
      _firestore.collection('match_requests');
  CollectionReference get chatRoomsCollection => 
      _firestore.collection('chat_rooms');
  CollectionReference get messagesCollection => 
      _firestore.collection('messages');

  // User Operations
  Future<void> createUserProfile(UserModel user) async {
    await usersCollection.doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    await usersCollection.doc(uid).update(updates);
  }

  // Match Operations
  Future<void> sendInterest(MatchRequest request) async {
    await matchRequestsCollection.doc(request.id).set(request.toMap());
  }

  Future<List<MatchRequest>> getPendingRequests(String userId) async {
    try {
      final snapshot = await matchRequestsCollection
          .where('toUserId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MatchRequest.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> respondToRequest(
    String requestId,
    InterestStatus status,
  ) async {
    await matchRequestsCollection.doc(requestId).update({
      'status': status.toString().split('.').last,
      'respondedAt': FieldValue.serverTimestamp(),
    });
  }

  // Search Profiles
  Future<List<UserModel>> searchProfiles({
    required Gender gender,
    int? minAge,
    int? maxAge,
    String? city,
    String? state,
    String? education,
    String? subCaste,
    int limit = 20,
  }) async {
    try {
      Query query = usersCollection.where('gender', isEqualTo: gender.toString().split('.').last);

      // Apply filters
      if (minAge != null || maxAge != null) {
        final now = DateTime.now();
        final minDob = maxAge != null 
            ? DateTime(now.year - maxAge - 1, now.month, now.day)
            : null;
        final maxDob = minAge != null
            ? DateTime(now.year - minAge, now.month, now.day)
            : null;

        if (minDob != null) {
          query = query.where('dateOfBirth', isGreaterThanOrEqualTo: Timestamp.fromDate(minDob));
        }
        if (maxDob != null) {
          query = query.where('dateOfBirth', isLessThanOrEqualTo: Timestamp.fromDate(maxDob));
        }
      }

      if (city != null && city.isNotEmpty) {
        query = query.where('city', isEqualTo: city);
      }

      if (state != null && state.isNotEmpty) {
        query = query.where('state', isEqualTo: state);
      }

      if (education != null && education.isNotEmpty) {
        query = query.where('education', isEqualTo: education);
      }

      if (subCaste != null && subCaste.isNotEmpty) {
        query = query.where('subCaste', isEqualTo: subCaste);
      }

      final snapshot = await query.limit(limit).get();

      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Chat Operations
  Future<String> createChatRoom(List<String> participants) async {
    final chatRoomId = participants.join('_');
    
    await chatRoomsCollection.doc(chatRoomId).set({
      'id': chatRoomId,
      'participants': participants,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isActive': true,
    });

    return chatRoomId;
  }

  Future<void> sendMessage(Message message) async {
    await messagesCollection.add(message.toMap());
    
    // Update chat room last message
    await chatRoomsCollection.doc(message.chatRoomId).update({
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': message.toMap(),
    });
  }

  Stream<QuerySnapshot> getMessagesStream(String chatRoomId) {
    return messagesCollection
        .where('chatRoomId', isEqualTo: chatRoomId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserChatRooms(String userId) {
    return chatRoomsCollection
        .where('participants', arrayContains: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }
}