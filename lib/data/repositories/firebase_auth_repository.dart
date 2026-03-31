import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserProfile?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _getUserProfile(credential.user?.uid);
    } catch (e) {
      // Basic print for now; log or rethrow for ViewModel
      debugPrint('Sign In Error: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfile?> signUpWithEmail(
    String email,
    String password,
    String name,
    String role,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user?.uid;
      if (uid == null) return null;

      final profile = UserProfile(
        id: uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );

      // Save user profile to Firestore with a timeout to catch uncreated DBs
      await _firestore
          .collection('users')
          .doc(uid)
          .set(profile.toMap())
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception(
              'Firestore timeout. Have you created the Firestore Database in your Firebase Console?');
        },
      );

      return profile;
    } catch (e) {
      debugPrint('Sign Up Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    final uid = _firebaseAuth.currentUser?.uid;
    return _getUserProfile(uid);
  }

  Future<UserProfile?> _getUserProfile(String? uid) async {
    if (uid == null) return null;
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      debugPrint('Get User Error: $e');
    }
    return null;
  }
}
