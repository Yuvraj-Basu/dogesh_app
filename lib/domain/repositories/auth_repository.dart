import '../models/user_profile.dart';

abstract class AuthRepository {
  /// Sign in using username (email) and password
  Future<UserProfile?> signInWithEmail(String email, String password);

  /// Sign up with email, password, and custom attributes like role
  Future<UserProfile?> signUpWithEmail(
    String email,
    String password,
    String name,
    String role,
  );

  /// Sign out current user
  Future<void> signOut();

  /// Get the currently logged-in user if available from local cache
  Future<UserProfile?> getCurrentUser();
}
