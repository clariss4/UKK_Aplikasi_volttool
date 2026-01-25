import 'package:apk_peminjaman/Widgets/colored_text_field.dart';
import 'package:apk_peminjaman/controllers/register_controller.dart';
import 'package:apk_peminjaman/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterAdminScreen extends StatefulWidget {
  const RegisterAdminScreen({super.key});

  @override
  State<RegisterAdminScreen> createState() => _RegisterAdminScreenState();
}

class _RegisterAdminScreenState extends State<RegisterAdminScreen> {
  final _controller = RegisterController();
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final error = await _controller.register(
      nama: _namaController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() => _loading = false);

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFB923C),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight * 0.6),
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ===== TITLE =====
                    const Text(
                      'Registrasi',
                      style: TextStyle(
                        fontFamily: 'HammersmithOne',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ===== NAMA =====
                    ColoredTextField(
                      controller: _namaController,
                      hint: 'Nama lengkap..',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ===== USERNAME =====
                    ColoredTextField(
                      controller: _usernameController,
                      hint: 'Username..',
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
                    SizedBox(
                      width: 334,
                      height: 69,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          fontFamily: 'HammersmithOne',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password..',
                          hintStyle: const TextStyle(
                            fontFamily: 'HammersmithOne',
                            color: Colors.black38,
                          ),

                          // 👉 ISI DALAM FIELD
                          filled: true,
                          fillColor: Colors.white,

                          // 👉 PADDING DALAM
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 22,
                          ),

                          // 👉 ICON MATA
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),

                          // ===== BORDER NORMAL =====
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE6E2DD),
                              width: 1.5,
                            ),
                          ),

                          // ===== BORDER SAAT DIKLIK =====
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE6E2DD), // 🔥 TETAP SAMA
                              width: 1.5,
                            ),
                          ),

                          // ===== BORDER ERROR =====
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),

                          // ===== BORDER ERROR + FOCUS =====
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                        ),
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
                    ),

                    const SizedBox(height: 32),

                    // ===== BUTTON =====
                    SizedBox(
                      width: 334,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFB923C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _loading ? 'Loading...' : 'Register sebagai admin',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'HammersmithOne',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== FIXED SIZE INPUT (334 x 69) =====
  Widget _fixedInputField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return SizedBox(
      width: 334,
      height: 69,
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: const TextStyle(fontFamily: 'HammersmithOne', fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontFamily: 'HammersmithOne'),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 22,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
