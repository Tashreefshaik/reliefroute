import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  User? _userDetails;

  User? get currentUser => _currentUser;
  User? get userDetails => _userDetails;
  bool get isAuthenticated => _currentUser != null;

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
    required String address,
  }) async {
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
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    print('AuthService.login called with email: $email');
    _currentUser = User(
      userId: 'demo_user_id',
      fullName: 'Demo User',
      email: email,
      phone: '1234567890',
      role: 'patient',
      address: 'Demo Address',
    );
    _userDetails = _currentUser;
    print('User set: ${_currentUser?.email}, role: ${_currentUser?.role}');
    print('Notifying listeners...');
    notifyListeners();
    print('Listeners notified');
  }

  Future<void> logout() async {
    _currentUser = null;
    _userDetails = null;
    notifyListeners();
  }
}
