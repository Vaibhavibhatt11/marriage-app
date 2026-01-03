import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:brahmin_marriage/Services/screens/home/profile_card.dart';
import 'package:brahmin_marriage/models/profile_model.dart';

void main() {
  testWidgets('ProfileCard displays name and city',
      (WidgetTester tester) async {
    final profile = ProfileModel(
      uid: 'u1',
      name: 'Test User',
      age: 30,
      gotra: 'X',
      education: 'BSc',
      profession: 'Engineer',
      city: 'City',
      imageUrl: '',
    );

    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ProfileCard(profile: profile))));

    expect(find.text('Test User'), findsOneWidget);
    expect(find.textContaining('City'), findsOneWidget);
  });
}
