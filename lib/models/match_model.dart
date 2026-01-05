import 'package:cloud_firestore/cloud_firestore.dart';

enum InterestStatus { pending, accepted, rejected }

class MatchRequest {
  final String id;
  final String fromUserId;
  final String toUserId;
  final InterestStatus status;
  final String? message;
  final DateTime createdAt;
  final DateTime? respondedAt;

  MatchRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    this.message,
    required this.createdAt,
    this.respondedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': status.toString().split('.').last,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'respondedAt': respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
    };
  }

  factory MatchRequest.fromMap(Map<String, dynamic> map) {
    return MatchRequest(
      id: map['id'],
      fromUserId: map['fromUserId'],
      toUserId: map['toUserId'],
      status: InterestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
      ),
      message: map['message'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      respondedAt: map['respondedAt'] != null 
          ? (map['respondedAt'] as Timestamp).toDate() 
          : null,
    );
  }
}

class ChatRoom {
  final String id;
  final List<String> participants;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? lastMessage;
  final bool isActive;

  ChatRoom({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participants': participants,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastMessage': lastMessage,
      'isActive': isActive,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      participants: List<String>.from(map['participants']),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'],
      isActive: map['isActive'],
    );
  }
}

class Message {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String messageType; // text, image

  Message({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.messageType = 'text',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'messageType': messageType,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      chatRoomId: map['chatRoomId'],
      senderId: map['senderId'],
      content: map['content'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isRead: map['isRead'],
      messageType: map['messageType'],
    );
  }
}