import 'package:flutter/foundation.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  UserProfile? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initializeUser() async {
    setLoading(true);
    _currentUser = await _authRepository.getCurrentUser();
    setLoading(false);
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    _errorMessage = null;
    try {
      _currentUser = await _authRepository.signInWithEmail(email, password);
      setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _errorMessage = e.toString();
      setLoading(false);
      return false;
    }
  }

  Future<bool> signUp(
    String email,
    String password,
    String name,
    String role,
  ) async {
    setLoading(true);
    _errorMessage = null;
    try {
      _currentUser = await _authRepository.signUpWithEmail(
          email, password, name, role);
      setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _errorMessage = e.toString();
      setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.signOut();
    _currentUser = null;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
