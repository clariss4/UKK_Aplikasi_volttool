import 'package:apk_peminjaman/services/supabase_service.dart';

class AuthService {
  Future<void> register({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Registrasi gagal');
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login gagal');
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  bool isLoggedIn() {
    return supabase.auth.currentUser != null;
  }
}
