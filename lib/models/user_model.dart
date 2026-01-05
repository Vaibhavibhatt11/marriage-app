import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { male, female }
enum MaritalStatus { single, divorced, widowed }
enum SubscriptionTier { free, premium, gold }

class UserModel {
  final String uid;
  final String email;
  final String phoneNumber;
  final String? profilePhoto;
  final String fullName;
  final Gender gender;
  final DateTime dateOfBirth;
  final String gotra;
  final String subCaste;
  final String education;
  final String occupation;
  final double annualIncome;
  final double height; // in cm
  final String city;
  final String state;
  final String country;
  final MaritalStatus maritalStatus;
  final String familyDetails;
  final String bio;
  final List<String> profilePhotos;
  final bool isProfileVerified;
  final SubscriptionTier subscriptionTier;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> blockedUsers;
  final Map<String, dynamic> preferences;

  UserModel({
    required this.uid,
    required this.email,
    required this.phoneNumber,
    this.profilePhoto,
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    required this.gotra,
    required this.subCaste,
    required this.education,
    required this.occupation,
    required this.annualIncome,
    required this.height,
    required this.city,
    required this.state,
    required this.country,
    required this.maritalStatus,
    required this.familyDetails,
    required this.bio,
    required this.profilePhotos,
    this.isProfileVerified = false,
    this.subscriptionTier = SubscriptionTier.free,
    required this.createdAt,
    required this.updatedAt,
    this.blockedUsers = const [],
    this.preferences = const {},
  });

  // Helper getter
  int get age {
    final now = DateTime.now();
    return now.year - dateOfBirth.year;
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePhoto': profilePhoto,
      'fullName': fullName,
      'gender': gender.toString().split('.').last,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'gotra': gotra,
      'subCaste': subCaste,
      'education': education,
      'occupation': occupation,
      'annualIncome': annualIncome,
      'height': height,
      'city': city,
      'state': state,
      'country': country,
      'maritalStatus': maritalStatus.toString().split('.').last,
      'familyDetails': familyDetails,
      'bio': bio,
      'profilePhotos': profilePhotos,
      'isProfileVerified': isProfileVerified,
      'subscriptionTier': subscriptionTier.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'blockedUsers': blockedUsers,
      'preferences': preferences,
    };
  }

  // Create from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      profilePhoto: map['profilePhoto'],
      fullName: map['fullName'],
      gender: Gender.values.firstWhere(
        (e) => e.toString().split('.').last == map['gender'],
      ),
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      gotra: map['gotra'],
      subCaste: map['subCaste'],
      education: map['education'],
      occupation: map['occupation'],
      annualIncome: map['annualIncome'].toDouble(),
      height: map['height'].toDouble(),
      city: map['city'],
      state: map['state'],
      country: map['country'],
      maritalStatus: MaritalStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['maritalStatus'],
      ),
      familyDetails: map['familyDetails'],
      bio: map['bio'],
      profilePhotos: List<String>.from(map['profilePhotos']),
      isProfileVerified: map['isProfileVerified'],
      subscriptionTier: SubscriptionTier.values.firstWhere(
        (e) => e.toString().split('.').last == map['subscriptionTier'],
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      blockedUsers: List<String>.from(map['blockedUsers'] ?? []),
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
    );
  }
}