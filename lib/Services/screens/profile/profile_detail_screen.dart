import 'package:flutter/material.dart';
import 'package:brahmin_marriage/models/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brahmin_marriage/Services/database_service.dart';

class ProfileDetailScreen extends StatefulWidget {
  final ProfileModel profile;
  const ProfileDetailScreen({super.key, required this.profile});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final DatabaseService _db = DatabaseService();
  String? currentUid;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid != null) {
      _db.getLikesByUser(currentUid!).listen((likes) {
        if (!mounted) return;
        setState(() {
          isLiked = likes.contains(widget.profile.uid);
        });
      });
    }
  }

  void toggleLike() async {
    if (currentUid == null) return;
    if (isLiked) {
      await _db.unlikeProfile(currentUid!, widget.profile.uid);
    } else {
      await _db.likeProfile(currentUid!, widget.profile.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.profile;
    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  p.imageUrl.isNotEmpty ? NetworkImage(p.imageUrl) : null,
              child: p.imageUrl.isEmpty
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 12),
            Text(p.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${p.age} • ${p.city}'),
            const SizedBox(height: 16),
            ListTile(title: const Text('Gotra'), subtitle: Text(p.gotra)),
            ListTile(
                title: const Text('Education'), subtitle: Text(p.education)),
            ListTile(
                title: const Text('Profession'), subtitle: Text(p.profession)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: toggleLike,
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                  label: Text(isLiked ? 'Liked' : 'Like'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
