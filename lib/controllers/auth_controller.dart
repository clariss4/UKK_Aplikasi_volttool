import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final SupabaseClient _client = Supabase.instance.client;

  /// LOGIN ADMIN
  Future<void> login(String usernameInput, String password) async {
    final data = await _client
        .from('users')
        .select()
        .eq('username', usernameInput)
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
    final name = data['nama_lengkap']?.toString();
    final username = data['username']?.toString();

    if (userId == null || role == null || name == null || username == null) {
      throw Exception('Data user tidak lengkap di database');
    }

    // SIMPAN SESSION
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', userId);
    await prefs.setString('role', role);
    await prefs.setString('name', name);
    await prefs.setString('username', username);
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
