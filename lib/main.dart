import 'package:apk_peminjaman/controllers/alat_controller.dart';
import 'package:apk_peminjaman/controllers/kategori_controller.dart';
import 'package:apk_peminjaman/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rxsgmuqbcpshdufjejxk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ4c2dtdXFiY3BzaGR1ZmplanhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzMjc1NDMsImV4cCI6MjA4MzkwMzU0M30.EcWfJt1dZDbJG9hrFsyZvi_iCNp0ZVYXIVnglIX9xSA',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KategoriController()),
        ChangeNotifierProvider(create: (_) => AlatController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
