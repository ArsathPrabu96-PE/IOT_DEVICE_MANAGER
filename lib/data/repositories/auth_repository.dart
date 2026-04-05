import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  Future<UserModel?> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<UserModel?> signup(String email, String password) {
    return _authService.signup(email, password);
  }

  Future<void> logout() {
    return _authService.logout();
  }
}