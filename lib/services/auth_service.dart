import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  firebase_auth.FirebaseAuth? _auth;
  User? _currentUser;
  User? _userDetails;
  bool _useMock = false;

  User? get currentUser => _currentUser;
  User? get userDetails => _userDetails;
  bool get isAuthenticated => _currentUser != null;

  AuthService() {
    try {
      _auth = firebase_auth.FirebaseAuth.instance;
      _auth!.authStateChanges().listen((firebase_auth.User? user) {
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
    } catch (e) {
      print('Firebase Auth not available, using mock authentication: $e');
      _useMock = true;
      _auth = null;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
    required String address,
  }) async {
    if (_useMock || _auth == null) {
      // Mock registration
      _currentUser = User(
        userId: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
        address: address,
      );
      _userDetails = _currentUser;
      notifyListeners();
      return;
    }

    try {
      final userCredential = await _auth!.createUserWithEmailAndPassword(
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
    if (_useMock || _auth == null) {
      // Mock login - check for known test users
      String role = 'patient';
      if (email.contains('pharmacist')) role = 'pharmacist';
      else if (email.contains('driver')) role = 'driver';
      else if (email.contains('admin')) role = 'admin';

      _currentUser = User(
        userId: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: 'Test User',
        email: email,
        phone: '',
        role: role,
        address: '',
      );
      _userDetails = _currentUser;
      notifyListeners();
      return;
    }

    try {
      final userCredential = await _auth!.signInWithEmailAndPassword(
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
    if (_auth != null) {
      await _auth!.signOut();
    }
    _currentUser = null;
    _userDetails = null;
    notifyListeners();
  }
}
