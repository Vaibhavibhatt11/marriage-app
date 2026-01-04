import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

// Screens
import 'Services/screens/auth/login_screen.dart';
import 'Services/screens/profile/create_profile_screen.dart';
import 'Services/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔑 Load .env file
  await dotenv.load(fileName: ".env");

  // 🔥 Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brahmin Marriage',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/createProfile': (context) => const CreateProfileScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
