import 'package:apk_peminjaman/Widgets/colored_text_field.dart';
import 'package:apk_peminjaman/controllers/auth_controller.dart';
import 'package:apk_peminjaman/screens/admin/dashboard_admin_screen.dart';
import 'package:apk_peminjaman/screens/admin/registrer_admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthController();
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _loginError;

  Future<void> _login() async {
    setState(() => _loginError = null);

    // VALIDASI CLIENT-SIDE hanya saat tekan tombol login
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await _auth.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      setState(() {
        _loginError = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFB923C),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ===== LOGO =====
              Image.asset('assets/images/logo.png', width: 220, height: 220),

              const SizedBox(height: 8),

              // ===== LOGIN CARD =====
              Container(
                width: 350,
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(minHeight: 380),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Login',
                        style: GoogleFonts.hammersmithOne(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ===== USERNAME =====
                      ColoredTextField(
                        controller: _usernameController,
                        hint: 'Username',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username wajib diisi';
                          }
                          final regex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@volttool\.com$',
                          );
                          if (!regex.hasMatch(value)) {
                            return 'Gunakan email @volttool.com';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ===== PASSWORD =====
                      ColoredTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        isPassword: true, // sembunyikan password
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password wajib diisi';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // ===== LOGIN BUTTON =====
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFB923C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontFamily: 'HammersmithOne',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      // ===== ERROR LOGIN =====
                      if (_loginError != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _loginError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // ===== REGISTER LINK =====
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterAdminScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Registrasi Admin',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
