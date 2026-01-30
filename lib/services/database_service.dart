import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kategori.dart';
import '../models/alat.dart';

class DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  /* ================= USER ================= */

  Future<void> registerAdmin({
    required String namaLengkap,
    required String username,
    required String password,
  }) async {
    await _client.from('users').insert({
      'nama_lengkap': namaLengkap,
      'username': username,
      'password': password,
      'role': 'admin',
      'is_active': true,
    });
  }

  /* ================= KATEGORI ================= */

  /// REALTIME STREAM KATEGORI
  Stream<List<Kategori>> streamKategori() {
    return _client
        .from('kategori_alat')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .order('created_at')
        .map((data) =>
            data.map((e) => Kategori.fromJson(e)).toList());
  }

  Future<void> insertKategori(Map<String, dynamic> data) async {
    await _client.from('kategori_alat').insert(data);
  }

  Future<void> updateKategori(String id, Map<String, dynamic> data) async {
    await _client.from('kategori_alat').update(data).eq('id', id);
  }

  /// SOFT DELETE
  Future<void> deleteKategori(String id) async {
    await _client
        .from('kategori_alat')
        .update({'is_active': false}).eq('id', id);
  }

  /* ================= ALAT ================= */

  /// REALTIME STREAM ALAT
  Stream<List<Alat>> streamAlat() {
    return _client
        .from('alat')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .order('created_at')
        .map((data) => data.map((e) => Alat.fromJson(e)).toList());
  }

  Future<void> insertAlat(Map<String, dynamic> data) async {
    await _client.from('alat').insert(data);
  }

  Future<void> updateAlat(String id, Map<String, dynamic> data) async {
    await _client.from('alat').update(data).eq('id', id);
  }

  /// SOFT DELETE
  Future<void> deleteAlat(String id) async {
    await _client.from('alat').update({'is_active': false}).eq('id', id);
  }

  /* ================= FOTO ================= */

  Future<String> uploadFotoAlat(File file) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage
        .from('alat')
        .upload(
          fileName,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from('alat').getPublicUrl(fileName);
  }
}
