import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'patient/home_screen.dart';
import 'pharmacist/pharmacist_home.dart';
import 'driver/driver_home.dart';
import 'admin/admin_home.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        if (authService.isAuthenticated) {
          final user = authService.userDetails;
          final role = user?.role ?? 'patient';

          switch (role.toLowerCase()) {
            case 'pharmacist':
              return const PharmacistHome();
            case 'driver':
              return const DriverHome();
            case 'admin':
              return const AdminHome();
            case 'patient':
            default:
              return const PatientHomeScreen();
          }
        }
        return const LoginScreen();
      },
    );
  }
}
