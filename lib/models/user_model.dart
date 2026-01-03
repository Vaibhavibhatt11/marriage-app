class UserModel {
  final String uid;
  final String phone;

  UserModel({
    required this.uid,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phone': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      phone: map['phone'],
    );
  }
}
