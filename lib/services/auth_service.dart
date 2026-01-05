import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:brahmin_matrimony/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream of User Authentication State
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Phone OTP Authentication
  Future<String?> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign in with Email & Password
  Future<(User?, String?)> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return (credential.user, null);
    } on FirebaseAuthException catch (e) {
      return (null, e.message);
    }
  }

  // Register with Email & Password
  Future<(User?, String?)> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return (credential.user, null);
    } on FirebaseAuthException catch (e) {
      return (null, e.message);
    }
  }

  // Sign in with Phone OTP
  Future<(User?, String?)> signInWithPhoneOTP(
    String verificationId,
    String smsCode,
  ) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return (userCredential.user, null);
    } on FirebaseAuthException catch (e) {
      return (null, e.message);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send Password Reset Email
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Update Email
  Future<String?> updateEmail(String newEmail) async {
    try {
      await currentUser!.updateEmail(newEmail);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Update Password
  Future<String?> updatePassword(String newPassword) async {
    try {
      await currentUser!.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Delete Account
  Future<String?> deleteAccount() async {
    try {
      await currentUser!.delete();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}