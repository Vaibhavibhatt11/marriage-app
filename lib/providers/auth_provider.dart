import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brahmin_matrimony/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authProvider);
  return authService.authStateChanges;
});
