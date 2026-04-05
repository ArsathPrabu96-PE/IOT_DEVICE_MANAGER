import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../core/constants/app_strings.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserModel?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return await _getUserData(credential.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserModel?> signup(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final user = UserModel(
          uid: credential.user!.uid,
          email: email,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set(user.toFirestore());
        await _createMockDevice(user.uid);

        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UserModel?> _getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _createMockDevice(String userId) async {
    final now = DateTime.now();
    await _firestore.collection('devices').add({
      'userId': userId,
      'name': 'Living Room Sensor',
      'temperature': 31.5,
      'status': 'on',
      'lastUpdated': Timestamp.fromDate(now),
      'createdAt': Timestamp.fromDate(now),
      'isOnline': true,
    });
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-email':
        return AppStrings.errorLoginFailed;
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return AppStrings.errorWeakPassword;
      case 'invalid-credential':
        return AppStrings.errorLoginFailed;
      default:
        return AppStrings.errorUnknown;
    }
  }
}