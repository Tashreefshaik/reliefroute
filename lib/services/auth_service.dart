import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  User? _userDetails;

  User? get currentUser => _currentUser;
  User? get userDetails => _userDetails;
  bool get isAuthenticated => _currentUser != null;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
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
