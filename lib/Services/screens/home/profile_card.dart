import 'package:flutter/material.dart';
import 'package:brahmin_marriage/models/profile_model.dart';
import 'package:brahmin_marriage/Services/screens/profile/profile_detail_screen.dart';

class ProfileCard extends StatelessWidget {
  final ProfileModel profile;
  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: profile.imageUrl.isNotEmpty
              ? NetworkImage(profile.imageUrl)
              : null,
          child: profile.imageUrl.isEmpty ? const Icon(Icons.person) : null,
        ),
        title: Text(profile.name),
        subtitle: Text("${profile.age} • ${profile.city}"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ProfileDetailScreen(profile: profile)),
          );
        },
      ),
    );
  }
}
