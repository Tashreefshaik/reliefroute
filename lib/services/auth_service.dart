import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  User? _currentUser;
  User? _userDetails;

  User? get currentUser => _currentUser;
  User? get userDetails => _userDetails;
  bool get isAuthenticated => _currentUser != null;

  AuthService() {
    _auth.authStateChanges().listen((firebase_auth.User? user) {
      if (user != null) {
        _currentUser = User(
          userId: user.uid,
          fullName: user.displayName ?? 'User',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          role: 'patient',
          address: '',
        );
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
    required String address,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _currentUser = User(
        userId: userCredential.user?.uid ?? '',
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
        address: address,
      );
      _userDetails = _currentUser;
      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _currentUser = User(
        userId: userCredential.user?.uid ?? '',
        fullName: userCredential.user?.displayName ?? 'User',
        email: email,
        phone: '',
        role: 'patient',
        address: '',
      );
      _userDetails = _currentUser;
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    _userDetails = null;
    notifyListeners();
  }
}
