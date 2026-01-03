import 'package:brahmin_marriage/models/profile_model.dart';
import 'package:flutter/material.dart';
import '../../database_service.dart';
import 'profile_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Brahmin Matches")),
      body: StreamBuilder<List<ProfileModel>>(
        stream: DatabaseService().getProfiles(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!
                .map((profile) => ProfileCard(profile: profile))
                .toList(),
          );
        },
      ),
    );
  }
}
