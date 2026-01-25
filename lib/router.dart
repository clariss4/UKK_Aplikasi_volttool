// // lib/router.dart
// import 'package:apk_peminjaman/screens/registrer_admin_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:apk_peminjaman/screens/dashboard_admin_screen.dart';
// import 'package:apk_peminjaman/screens/dashboard_petugas_screen.dart';
// import 'package:apk_peminjaman/screens/login_screen.dart';
// import 'package:apk_peminjaman/screens/splash_screen.dart';

// class AppRouter {
//   static final routes = {
//     '/': (context) => SplashScreen(),
//     '/login': (context) => LoginScreen(),
//     '/register': (context) => RegisterAdminScreen(),
//     '/dashboard_admin': (context) => DashboardScreen(),
//     '/dashboard_petugas': (context) => DashboardPetugasScreen(),
//   };

//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     // Pastikan settings.name tidak null
//     final String? routeName = settings.name;
//     if (routeName != null && routes.containsKey(routeName)) {
//       return MaterialPageRoute(builder: (context) => routes[routeName]!(context));
//     }
//     // Jika rute tidak ditemukan, arahkan ke halaman splash screen
//     return MaterialPageRoute(builder: (context) => SplashScreen());
//   }
// }