import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> registerAdmin({
    required String namaLengkap,
    required String username,
    required String password,
  }) async {
    await _client.from('users').insert({
      'nama_lengkap': namaLengkap,
      'username': username,
      'password': password, // sementara plain text
      'role': 'admin',
      'is_active': true,
    });
  }
}
