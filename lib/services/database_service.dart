import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kategori.dart';
import '../models/alat.dart';

class DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  /* ================= USER ================= */

  /// STREAM REALTIME USERS
  Stream<List<Map<String, dynamic>>> streamUsers() {
    return _client
        .from('users')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  /// GET ALL USERS
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await _client
        .from('users')
        .select()
        .eq('is_active', true)
        .order('created_at');
    return List<Map<String, dynamic>>.from(response);
  }

  /// GET USER BY ID
  Future<Map<String, dynamic>?> getUserById(String id) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', id)
        .single();
    return response;
  }

  /// INSERT USER (bisa semua role)
  Future<void> insertUser(Map<String, dynamic> data) async {
    data['is_active'] = true; // pastikan selalu aktif saat insert
    await _client.from('users').insert(data);
  }

  /// UPDATE USER
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _client.from('users').update(data).eq('id', id);
  }

  /// SOFT DELETE USER
  Future<void> deleteUser(String id) async {
    await _client.from('users').update({'is_active': false}).eq('id', id);
  }

  /* ================= KATEGORI ALAT ================= */

  Stream<List<Kategori>> streamKategori() {
    return _client
        .from('kategori_alat')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .order('created_at')
        .map((data) => data.map((e) => Kategori.fromJson(e)).toList());
  }

  Future<List<Kategori>> getKategori() async {
    final response = await _client
        .from('kategori_alat')
        .select()
        .eq('is_active', true)
        .order('created_at');
    return (response as List).map((e) => Kategori.fromJson(e)).toList();
  }

  Future<Kategori?> getKategoriById(String id) async {
    final response = await _client
        .from('kategori_alat')
        .select()
        .eq('id', id)
        .single();
    return Kategori.fromJson(response);
  }

  Future<void> insertKategori(Map<String, dynamic> data) async {
    await _client.from('kategori_alat').insert(data);
  }

  Future<void> updateKategori(String id, Map<String, dynamic> data) async {
    await _client.from('kategori_alat').update(data).eq('id', id);
  }

  Future<void> deleteKategori(String id) async {
    await _client
        .from('kategori_alat')
        .update({'is_active': false}).eq('id', id);
  }

  /* ================= ALAT ================= */

  Stream<List<Alat>> streamAlat() {
    return _client
        .from('alat')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .order('created_at')
        .map((data) => data.map((e) => Alat.fromJson(e)).toList());
  }

  Future<List<Alat>> getAlat() async {
    final response = await _client
        .from('alat')
        .select()
        .eq('is_active', true)
        .order('created_at');
    return (response as List).map((e) => Alat.fromJson(e)).toList();
  }

  Future<Alat?> getAlatById(String id) async {
    final response = await _client
        .from('alat')
        .select()
        .eq('id', id)
        .single();
    return Alat.fromJson(response);
  }

  Future<void> insertAlat(Map<String, dynamic> data, {File? fotoFile}) async {
    if (fotoFile != null) {
      final fotoUrl = await uploadFotoAlat(fotoFile);
      data['foto_url'] = fotoUrl;
    }
    data['is_active'] = true; // pastikan aktif
    await _client.from('alat').insert(data);
  }

  Future<void> updateAlat(String id, Map<String, dynamic> data, {File? fotoFile}) async {
    if (fotoFile != null) {
      final fotoUrl = await uploadFotoAlat(fotoFile);
      data['foto_url'] = fotoUrl;
    }
    await _client.from('alat').update(data).eq('id', id);
  }

  Future<void> deleteAlat(String id) async {
    await _client.from('alat').update({'is_active': false}).eq('id', id);
  }

  Future<String> uploadFotoAlat(File file) async {
    final fileName = 'alat_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final bytes = await file.readAsBytes();
    await _client.storage.from('alat').uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );
    return _client.storage.from('alat').getPublicUrl(fileName);
  }

  /* ================= PEMINJAMAN ================= */

  Stream<List<Map<String, dynamic>>> streamPeminjaman() {
    return _client
        .from('peminjaman')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  Future<List<Map<String, dynamic>>> getPeminjaman() async {
    final response = await _client
        .from('peminjaman')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getPeminjamanById(String id) async {
    final response = await _client
        .from('peminjaman')
        .select()
        .eq('id', id)
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getPeminjamanDetail(String peminjamanId) async {
    final response = await _client
        .from('peminjaman_detail')
        .select('*, alat(*)')
        .eq('peminjaman_id', peminjamanId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> insertPeminjaman({
    required Map<String, dynamic> peminjamanData,
    required List<Map<String, dynamic>> detailData,
  }) async {
    final peminjamanResponse = await _client
        .from('peminjaman')
        .insert(peminjamanData)
        .select()
        .single();

    final peminjamanId = peminjamanResponse['id'];

    final detailWithId = detailData.map((detail) {
      return {...detail, 'peminjaman_id': peminjamanId};
    }).toList();

    await _client.from('peminjaman_detail').insert(detailWithId);
  }

  Future<void> updatePeminjaman(String id, Map<String, dynamic> data) async {
    await _client.from('peminjaman').update(data).eq('id', id);
  }

  Future<void> deletePeminjaman(String id) async {
    await _client.from('peminjaman_detail').delete().eq('peminjaman_id', id);
    await _client.from('peminjaman').delete().eq('id', id);
  }

  /* ================= PENGEMBALIAN ================= */

  Stream<List<Map<String, dynamic>>> streamPengembalian() {
    return _client
        .from('pengembalian')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  Future<List<Map<String, dynamic>>> getPengembalian() async {
    final response = await _client
        .from('pengembalian')
        .select('*, peminjaman(*)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getPengembalianById(String id) async {
    final response = await _client
        .from('pengembalian')
        .select('*, peminjaman(*)')
        .eq('id', id)
        .single();
    return response;
  }

  Future<void> insertPengembalian(Map<String, dynamic> data) async {
    await _client.from('pengembalian').insert(data);
  }

  Future<void> updatePengembalian(String id, Map<String, dynamic> data) async {
    await _client.from('pengembalian').update(data).eq('id', id);
  }

  Future<void> deletePengembalian(String id) async {
    await _client.from('denda').delete().eq('pengembalian_id', id);
    await _client.from('pengembalian').delete().eq('id', id);
  }

  /* ================= DENDA ================= */

  Stream<List<Map<String, dynamic>>> streamDenda() {
    return _client
        .from('denda')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  Future<List<Map<String, dynamic>>> getDenda() async {
    final response = await _client
        .from('denda')
        .select('*, pengembalian(*)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getDendaById(String id) async {
    final response = await _client
        .from('denda')
        .select('*, pengembalian(*)')
        .eq('id', id)
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getDendaByPengembalianId(String pengembalianId) async {
    final response = await _client
        .from('denda')
        .select()
        .eq('pengembalian_id', pengembalianId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateDenda(String id, Map<String, dynamic> data) async {
    await _client.from('denda').update(data).eq('id', id);
  }
}
