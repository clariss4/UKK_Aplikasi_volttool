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

  /// GET ALL USERS (non-admin)
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await _client
        .from('users')
        .select()
        .eq('is_active', true)
        .neq('role', 'admin')
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

  /// INSERT USER (petugas atau peminjam)
  Future<void> insertUser(Map<String, dynamic> data) async {
    await _client.from('users').insert(data);
  }

  /// UPDATE USER
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _client.from('users').update(data).eq('id', id);
  }

  /// SOFT DELETE USER
  Future<void> deleteUser(String id) async {
    await _client
        .from('users')
        .update({'is_active': false}).eq('id', id);
  }

  /* ================= KATEGORI ALAT ================= */

  /// REALTIME STREAM KATEGORI
  Stream<List<Kategori>> streamKategori() {
    return _client
        .from('kategori_alat')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .order('created_at')
        .map((data) => data.map((e) => Kategori.fromJson(e)).toList());
  }

  /// GET ALL KATEGORI
  Future<List<Kategori>> getKategori() async {
    final response = await _client
        .from('kategori_alat')
        .select()
        .eq('is_active', true)
        .order('created_at');
    return (response as List).map((e) => Kategori.fromJson(e)).toList();
  }

  /// GET KATEGORI BY ID
  Future<Kategori?> getKategoriById(String id) async {
    final response = await _client
        .from('kategori_alat')
        .select()
        .eq('id', id)
        .single();
    return Kategori.fromJson(response);
  }

  /// INSERT KATEGORI
  Future<void> insertKategori(Map<String, dynamic> data) async {
    await _client.from('kategori_alat').insert(data);
  }

  /// UPDATE KATEGORI
  Future<void> updateKategori(String id, Map<String, dynamic> data) async {
    await _client.from('kategori_alat').update(data).eq('id', id);
  }

  /// SOFT DELETE KATEGORI
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

  /// GET ALL ALAT
  Future<List<Alat>> getAlat() async {
    final response = await _client
        .from('alat')
        .select()
        .eq('is_active', true)
        .order('created_at');
    return (response as List).map((e) => Alat.fromJson(e)).toList();
  }

  /// GET ALAT BY ID
  Future<Alat?> getAlatById(String id) async {
    final response = await _client
        .from('alat')
        .select()
        .eq('id', id)
        .single();
    return Alat.fromJson(response);
  }

  /// INSERT ALAT (dengan upload foto)
  Future<void> insertAlat(Map<String, dynamic> data, {File? fotoFile}) async {
    if (fotoFile != null) {
      final fotoUrl = await uploadFotoAlat(fotoFile);
      data['foto_url'] = fotoUrl;
    }
    await _client.from('alat').insert(data);
  }

  /// UPDATE ALAT (dengan upload foto baru jika ada)
  Future<void> updateAlat(String id, Map<String, dynamic> data, {File? fotoFile}) async {
    if (fotoFile != null) {
      final fotoUrl = await uploadFotoAlat(fotoFile);
      data['foto_url'] = fotoUrl;
    }
    await _client.from('alat').update(data).eq('id', id);
  }

  /// SOFT DELETE ALAT
  Future<void> deleteAlat(String id) async {
    await _client.from('alat').update({'is_active': false}).eq('id', id);
  }

  /// UPLOAD FOTO ALAT
  Future<String> uploadFotoAlat(File file) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage.from('alat').upload(
          fileName,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from('alat').getPublicUrl(fileName);
  }

  /* ================= PEMINJAMAN ================= */

  /// REALTIME STREAM PEMINJAMAN
  Stream<List<Map<String, dynamic>>> streamPeminjaman() {
    return _client
        .from('peminjaman')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  /// GET ALL PEMINJAMAN
  Future<List<Map<String, dynamic>>> getPeminjaman() async {
    final response = await _client
        .from('peminjaman')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// GET PEMINJAMAN BY ID
  Future<Map<String, dynamic>?> getPeminjamanById(String id) async {
    final response = await _client
        .from('peminjaman')
        .select()
        .eq('id', id)
        .single();
    return response;
  }

  /// GET PEMINJAMAN DETAIL BY PEMINJAMAN ID
  Future<List<Map<String, dynamic>>> getPeminjamanDetail(String peminjamanId) async {
    final response = await _client
        .from('peminjaman_detail')
        .select('*, alat(*)')
        .eq('peminjaman_id', peminjamanId);
    return List<Map<String, dynamic>>.from(response);
  }

  /// INSERT PEMINJAMAN (dengan detail)
  Future<void> insertPeminjaman({
    required Map<String, dynamic> peminjamanData,
    required List<Map<String, dynamic>> detailData,
  }) async {
    // Insert peminjaman
    final peminjamanResponse = await _client
        .from('peminjaman')
        .insert(peminjamanData)
        .select()
        .single();

    final peminjamanId = peminjamanResponse['id'];

    // Insert detail dengan peminjaman_id
    final detailWithId = detailData.map((detail) {
      return {...detail, 'peminjaman_id': peminjamanId};
    }).toList();

    await _client.from('peminjaman_detail').insert(detailWithId);
  }

  /// UPDATE PEMINJAMAN
  Future<void> updatePeminjaman(String id, Map<String, dynamic> data) async {
    await _client.from('peminjaman').update(data).eq('id', id);
  }

  /// DELETE PEMINJAMAN (dengan detail)
  Future<void> deletePeminjaman(String id) async {
    // Delete detail terlebih dahulu
    await _client.from('peminjaman_detail').delete().eq('peminjaman_id', id);
    
    // Delete peminjaman
    await _client.from('peminjaman').delete().eq('id', id);
  }

  /* ================= PENGEMBALIAN ================= */

  /// REALTIME STREAM PENGEMBALIAN
  Stream<List<Map<String, dynamic>>> streamPengembalian() {
    return _client
        .from('pengembalian')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  /// GET ALL PENGEMBALIAN
  Future<List<Map<String, dynamic>>> getPengembalian() async {
    final response = await _client
        .from('pengembalian')
        .select('*, peminjaman(*)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// GET PENGEMBALIAN BY ID
  Future<Map<String, dynamic>?> getPengembalianById(String id) async {
    final response = await _client
        .from('pengembalian')
        .select('*, peminjaman(*)')
        .eq('id', id)
        .single();
    return response;
  }

  /// INSERT PENGEMBALIAN
  Future<void> insertPengembalian(Map<String, dynamic> data) async {
    await _client.from('pengembalian').insert(data);
  }

  /// UPDATE PENGEMBALIAN
  Future<void> updatePengembalian(String id, Map<String, dynamic> data) async {
    await _client.from('pengembalian').update(data).eq('id', id);
  }

  /// DELETE PENGEMBALIAN
  Future<void> deletePengembalian(String id) async {
    // Delete denda terkait terlebih dahulu
    await _client.from('denda').delete().eq('pengembalian_id', id);
    
    // Delete pengembalian
    await _client.from('pengembalian').delete().eq('id', id);
  }

  /* ================= DENDA (READ & UPDATE ONLY) ================= */

  /// REALTIME STREAM DENDA
  Stream<List<Map<String, dynamic>>> streamDenda() {
    return _client
        .from('denda')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  /// GET ALL DENDA
  Future<List<Map<String, dynamic>>> getDenda() async {
    final response = await _client
        .from('denda')
        .select('*, pengembalian(*)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// GET DENDA BY ID
  Future<Map<String, dynamic>?> getDendaById(String id) async {
    final response = await _client
        .from('denda')
        .select('*, pengembalian(*)')
        .eq('id', id)
        .single();
    return response;
  }

  /// GET DENDA BY PENGEMBALIAN ID
  Future<List<Map<String, dynamic>>> getDendaByPengembalianId(String pengembalianId) async {
    final response = await _client
        .from('denda')
        .select()
        .eq('pengembalian_id', pengembalianId);
    return List<Map<String, dynamic>>.from(response);
  }

  /// UPDATE DENDA
  Future<void> updateDenda(String id, Map<String, dynamic> data) async {
    await _client.from('denda').update(data).eq('id', id);
  }
}