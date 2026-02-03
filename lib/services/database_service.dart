import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kategori.dart';
import '../models/alat.dart';

class DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // ================= USER =================

  Stream<List<Map<String, dynamic>>> streamUsers() {
    return Stream.periodic(const Duration(milliseconds: 500)).asyncExpand((
      _,
    ) async* {
      final response = await _client
          .from('users')
          .select()
          .order('created_at', ascending: false);
      yield List<Map<String, dynamic>>.from(response);
    });
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await _client
        .from('users')
        .select()
        .eq('is_active', true)
        .order('created_at');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getUserById(String id) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', id)
        .maybeSingle();
    return response;
  }

  Future<void> insertUser(Map<String, dynamic> data) async {
    data['is_active'] = true;
    await _client.from('users').insert(data);
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _client.from('users').update(data).eq('id', id);
  }

  Future<void> deleteUser(String id) async {
    await _client.from('users').update({'is_active': false}).eq('id', id);
  }

  /* ================= STREAM ================= */

  // ✅ Stream untuk kategori yang aktif saja (untuk dropdown, dll)
  Stream<List<Kategori>> streamKategori() {
    return _client
        .from('kategori_alat')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .order('created_at')
        .map((rows) => rows.map((e) => Kategori.fromJson(e)).toList());
  }

  // ✅ Stream untuk SEMUA kategori (termasuk yang is_active = false)
 Stream<List<Kategori>> streamKategoriAll() {
  return _client
      .from('kategori')
      .stream(primaryKey: ['id'])
      .order('created_at')
      .map((data) => data.map(Kategori.fromJson).toList());
}


  // ✅ Stream untuk alat yang aktif saja
  Stream<List<Alat>> streamAlat() {
    return _client
        .from('alat')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .order('created_at')
        .map((rows) => rows.map((e) => Alat.fromJson(e)).toList());
  }

  // ✅ Stream untuk SEMUA alat (termasuk yang is_active = false)
  Stream<List<Alat>> streamAlatAll() {
    return _client
        .from('alat')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((rows) => rows.map((e) => Alat.fromJson(e)).toList());
  }

  // ================= GET KATEGORI =================
  Future<List<Kategori>> getKategori() async {
    try {
      final response = await _client
          .from('kategori_alat')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: true);
      return (response as List).map((json) => Kategori.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error getKategori: $e');
      return [];
    }
  }

  // ================= GET ALAT =================
  Future<List<Alat>> getAlat() async {
    try {
      final response = await _client
          .from('alat')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: true);
      return (response as List).map((json) => Alat.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error getAlat: $e');
      return [];
    }
  }

  /* ================= INSERT ================= */
  Future<void> insertKategori(Map<String, dynamic> data) async {
    try {
      final response = await _client.from('kategori_alat').insert({
        'nama_kategori': data['nama_kategori'],
        'is_active': data['is_active'] ?? true,
      }).select();

      debugPrint('✅ Insert kategori berhasil: $response');
    } catch (e) {
      debugPrint('❌ Error insertKategori: $e');
      debugPrint('❌ Error details: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> insertAlat(Map<String, dynamic> data, {dynamic fotoFile}) async {
    try {
      String? fotoUrl;

      if (fotoFile != null) {
        final fileName = 'alat_${DateTime.now().millisecondsSinceEpoch}.jpg';

        try {
          if (fotoFile is Uint8List) {
            await _client.storage
                .from('foto_alat')
                .uploadBinary(fileName, fotoFile);
          } else if (fotoFile is File) {
            await _client.storage.from('foto_alat').upload(fileName, fotoFile);
          }

          fotoUrl = _client.storage.from('foto_alat').getPublicUrl(fileName);
        } catch (storageError) {
          debugPrint('❌ Storage error: $storageError');
          // Jangan throw, lanjutkan tanpa foto
          fotoUrl = null;
        }
      }

      // Insert ke database
      await _client.from('alat').insert({
        'kategori_id': data['kategori_id'],
        'nama_alat': data['nama_alat'],
        'foto_url': fotoUrl,
        'stok_total': data['stok_total'],
        'stok_tersedia': data['stok_total'],
        'kondisi': data['kondisi'] ?? 'baik',
        'is_active': data['is_active'] ?? true,
      });

      debugPrint('✅ Insert alat berhasil');
    } catch (e) {
      debugPrint('❌ Error insertAlat: $e');
      rethrow;
    }
  }

  /* ================= UPDATE ================= */
Future<void> updateKategori(String id, Map<String, dynamic> data) async {
  debugPrint('🟡 UPDATE KATEGORI DIPANGGIL');
  debugPrint('ID: $id');
  debugPrint('DATA: $data');

  final response = await _client
      .from('kategori_alat')
      .update({
        'nama_kategori': data['nama_kategori'],
        'is_active': data['is_active'],
      })
      .eq('id', id)
      .select(); // 🔥 WAJIB

  debugPrint('🟢 RESPONSE UPDATE: $response');

  // 🔥 INI KUNCI UTAMANYA
  if (response.isEmpty) {
    throw Exception('Update gagal: ID kategori tidak ditemukan');
  }

  // 🔥 SOFT DELETE → nonaktifkan alat
  if (data['is_active'] == false) {
    final alatResponse = await _client
        .from('alat')
        .update({'is_active': false})
        .eq('kategori_id', id)
        .select();

    debugPrint('🟢 RESPONSE UPDATE ALAT: $alatResponse');
  }
}


  Future<void> updateAlat(
    String id,
    Map<String, dynamic> data, {
    dynamic fotoFile,
  }) async {
    final updateData = {
      'kategori_id': data['kategori_id'],
      'nama_alat': data['nama_alat'],
      'stok_total': data['stok_total'],
      'stok_tersedia': data['stok_tersedia'], // Tambahkan ini
      'kondisi': data['kondisi'],
      'is_active': data['is_active'],
    };

    if (fotoFile != null) {
      final fileName = 'alat_${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (fotoFile is Uint8List) {
        await _client.storage
            .from('foto_alat')
            .uploadBinary(fileName, fotoFile);
      } else if (fotoFile is File) {
        await _client.storage
            .from('foto_alat')
            .upload(fileName, fotoFile); // Perbaiki: 'foto_alat' bukan 'alat'
      }

      updateData['foto_url'] = _client.storage
          .from('foto_alat')
          .getPublicUrl(fileName); // Perbaiki: 'foto_alat' bukan 'alat'
    }

    await _client.from('alat').update(updateData).eq('id', id);
  }

  /* ================= DELETE (SOFT) ================= */
 Future<void> deleteKategori(String id) async {
  try {
    // Soft delete kategori
    await _client
        .from('kategori_alat')
        .update({'is_active': false})
        .eq('id', id);

    // Soft delete semua alat dalam kategori
    await _client
        .from('alat')
        .update({'is_active': false})
        .eq('kategori_id', id);
  } catch (e) {
    debugPrint('❌ Error deleteKategori: $e');
    rethrow;
  }
}

  Future<void> deleteAlat(String id) async {
    await _client.from('alat').update({'is_active': false}).eq('id', id);
  }

// ================= PEMINJAMAN =================

  /// STREAM peminjaman (realtime)
  Stream<List<Map<String, dynamic>>> streamPeminjaman() {
    return _client
        .from('peminjaman')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  /// GET peminjaman
  Future<List<Map<String, dynamic>>> getPeminjaman() async {
    final res = await _client
        .from('peminjaman')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  /// INSERT peminjaman
  Future<Map<String, dynamic>> insertPeminjaman(
      Map<String, dynamic> data) async {
    final res = await _client
        .from('peminjaman')
        .insert(data)
        .select()
        .single();

    return res;
  }

  /// UPDATE peminjaman
  Future<void> updatePeminjaman(
      String id, Map<String, dynamic> data) async {
    await _client
        .from('peminjaman')
        .update(data)
        .eq('id', id);
  }

  /// DELETE peminjaman
  Future<void> deletePeminjaman(String id) async {
    await _client
        .from('peminjaman')
        .delete()
        .eq('id', id);
  }

  // ================= PENGEMBALIAN =================

  /// STREAM pengembalian (realtime)
  Stream<List<Map<String, dynamic>>> streamPengembalian() {
    return _client
        .from('pengembalian')
        .stream(primaryKey: ['id'])
        .order('tanggal_kembali', ascending: false);
  }

  /// GET pengembalian
  Future<List<Map<String, dynamic>>> getPengembalian() async {
    final res = await _client
        .from('pengembalian')
        .select()
        .order('tanggal_kembali', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  /// INSERT pengembalian
  Future<Map<String, dynamic>> insertPengembalian(
      Map<String, dynamic> data) async {
    final res = await _client
        .from('pengembalian')
        .insert(data)
        .select()
        .single();

    return res;
  }

  /// UPDATE pengembalian
  Future<void> updatePengembalian(
      String id, Map<String, dynamic> data) async {
    await _client
        .from('pengembalian')
        .update(data)
        .eq('id', id);
  }

  /// DELETE pengembalian
  Future<void> deletePengembalian(String id) async {
    await _client
        .from('pengembalian')
        .delete()
        .eq('id', id);
  }
  // ================= DENDA =================

  Future<void> insertDenda(Map<String, dynamic> data) async {
    await _client.from('denda').insert(data);
  }

  Future<void> updateDenda(String id, Map<String, dynamic> data) async {
    await _client.from('denda').update(data).eq('id', id);
  }

  Future<void> deleteDenda(String id) async {
    await _client.from('denda').delete().eq('id', id);
  }
}
