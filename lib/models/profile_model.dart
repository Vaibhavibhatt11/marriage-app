class ProfileModel {
  final String uid;
  final String name;
  final int age;
  final String gotra;
  final String education;
  final String profession;
  final String city;
  final String imageUrl;

  ProfileModel({
    required this.uid,
    required this.name,
    required this.age,
    required this.gotra,
    required this.education,
    required this.profession,
    required this.city,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'age': age,
      'gotra': gotra,
      'education': education,
      'profession': profession,
      'city': city,
      'imageUrl': imageUrl,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map['uid'],
      name: map['name'],
      age: map['age'],
      gotra: map['gotra'],
      education: map['education'],
      profession: map['profession'],
      city: map['city'],
      imageUrl: map['imageUrl'],
    );
  }
}
