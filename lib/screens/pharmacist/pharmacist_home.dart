import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/theme_service.dart';
import 'prescription_verification_screen.dart';
import 'pharmacist_tracking_screen.dart';

class PharmacistHome extends StatelessWidget {
  const PharmacistHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: ThemeService.gradientBackground,
        child: Column(
          children: [
            AppBar(
              title: const Text('Pharmacist Dashboard'),
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
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color(0xFF087F8C),
                      unselectedLabelColor: Color(0xFF64748B),
                      tabs: [
                        Tab(text: 'Prescriptions'),
                        Tab(text: 'Delivery Tracking'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          const PrescriptionVerificationScreen(),
                          const PharmacistTrackingScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
