import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final SupabaseClient _client = Supabase.instance.client;

  /// LOGIN ADMIN
  Future<void> login(String username, String password) async {
    final data = await _client
        .from('users')
        .select()
        .eq('username', username)
        .eq('password', password)
        .maybeSingle(); // semua role bisa login

    if (data == null) {
      throw Exception('Username atau password salah');
    }

    if (data['is_active'] != true) {
      throw Exception('Akun tidak aktif');
    }

    // pastikan id dan role tidak null
    final userId = data['id']?.toString();
    final role = data['role']?.toString();

    if (userId == null || role == null) {
      throw Exception('Data user tidak lengkap di database');
    }

    // SIMPAN SESSION
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', userId);
    await prefs.setString('role', role);
  }

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  /// LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// CEK LOGIN
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  /// CEK ROLE (OPSIONAL, TAPI DISARANKAN)
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
}
