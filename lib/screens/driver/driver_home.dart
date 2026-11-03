import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/theme_service.dart';
import 'delivery_management_screen.dart';

class DriverHome extends StatelessWidget {
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: ThemeService.gradientBackground,
        child: Column(
          children: [
            AppBar(
              title: const Text('Driver Dashboard'),
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF123047),
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Color(0xFF087F8C)),
                  onPressed: () {
                    context.read<AuthService>().logout();
                  },
                ),
              ],
            ),
            const Expanded(
              child: DeliveryManagementScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
