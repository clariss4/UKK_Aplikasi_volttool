import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/alat_controller.dart';
import 'controllers/kategori_controller.dart';
import 'screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => KategoriController(),
        ),
        ChangeNotifierProvider(
          create: (_) => AlatController(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
