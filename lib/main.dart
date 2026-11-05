import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/cart_service.dart';
import 'services/theme_service.dart';
import 'services/favorite_service.dart';
import 'services/gps_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ReliefRouteApp());
}

class ReliefRouteApp extends StatelessWidget {
  const ReliefRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FirestoreService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => FavoriteService()),
        ChangeNotifierProvider(create: (_) => GPSService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, _) {
          return MaterialApp(
            title: 'ReliefRoute',
            debugShowCheckedModeBanner: false,
            theme: ThemeService.lightTheme,
            darkTheme: ThemeService.darkTheme,
            themeMode: themeService.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
