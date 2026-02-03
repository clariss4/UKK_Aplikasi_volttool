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

  /* ================= STREAM KATEGORI & ALAT ================= */

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
        .from('kategori_alat')
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

  /* ================= INSERT KATEGORI ================= */
  Future<void> insertKategori(Map<String, dynamic> data) async {
    try {
      debugPrint('🔵 insertKategori dipanggil dengan data: $data');

      final response = await _client.from('kategori_alat').insert({
        'nama_kategori': data['nama_kategori'],
        'is_active': data['is_active'] ?? true,
      }).select();

      debugPrint('✅ Insert kategori berhasil: $response');
    } catch (e) {
      debugPrint('❌ Error insertKategori: $e');
      rethrow;
    }
  }

  /* ================= INSERT ALAT ================= */
  Future<void> insertAlat(Map<String, dynamic> data, {dynamic fotoFile}) async {
    try {
      debugPrint('🔵 insertAlat dipanggil dengan data: $data');
      String? fotoUrl;

      // Upload foto jika ada
      if (fotoFile != null) {
        final fileName = 'alat_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storagePath = 'alat_images/$fileName'; // ✅ Tambahkan folder path

        try {
          // ✅ Gunakan bucket 'images' bukan 'foto_alat'
          if (fotoFile is Uint8List) {
            await _client.storage
                .from('images')
                .uploadBinary(storagePath, fotoFile);
          } else if (fotoFile is File) {
            await _client.storage
                .from('images')
                .upload(storagePath, fotoFile);
          }

          fotoUrl = _client.storage.from('images').getPublicUrl(storagePath);
          debugPrint('✅ Foto berhasil diupload: $fotoUrl');
        } catch (storageError) {
          debugPrint('❌ Storage error: $storageError');
          // Lanjutkan tanpa foto
          fotoUrl = null;
        }
      }

      // ✅ Pastikan stok_tersedia diset
      final stokTersedia = data['stok_tersedia'] ?? data['stok_total'];

      // Insert ke database
      final response = await _client.from('alat').insert({
        'kategori_id': data['kategori_id'],
        'nama_alat': data['nama_alat'],
        'foto_url': fotoUrl,
        'stok_total': data['stok_total'],
        'stok_tersedia': stokTersedia, // ✅ Gunakan variable
        'kondisi': data['kondisi'] ?? 'baik',
        'is_active': data['is_active'] ?? true,
      }).select();

      debugPrint('✅ Insert alat berhasil: $response');
    } catch (e) {
      debugPrint('❌ Error insertAlat: $e');
      rethrow;
    }
  }

  /* ================= UPDATE KATEGORI ================= */
  Future<void> updateKategori(String id, Map<String, dynamic> data) async {
    try {
      debugPrint('🔵 updateKategori dipanggil');
      debugPrint('ID: $id');
      debugPrint('DATA: $data');

      final response = await _client
          .from('kategori_alat')
          .update({
            'nama_kategori': data['nama_kategori'],
            'is_active': data['is_active'],
          })
          .eq('id', id)
          .select();

      debugPrint('✅ Response update kategori: $response');

      if (response.isEmpty) {
        throw Exception('Update gagal: ID kategori tidak ditemukan');
      }

      // Jika kategori dinonaktifkan, nonaktifkan semua alat dalam kategori
      if (data['is_active'] == false) {
        final alatResponse = await _client
            .from('alat')
            .update({'is_active': false})
            .eq('kategori_id', id)
            .select();

        debugPrint('✅ Response update alat: $alatResponse');
      }
    } catch (e) {
      debugPrint('❌ Error updateKategori: $e');
      rethrow;
    }
  }

  /* ================= UPDATE ALAT ================= */
  Future<void> updateAlat(
    String id,
    Map<String, dynamic> data, {
    dynamic fotoFile,
  }) async {
    try {
      debugPrint('🔵 updateAlat dipanggil');
      debugPrint('ID: $id');
      debugPrint('DATA: $data');

      final updateData = {
        'kategori_id': data['kategori_id'],
        'nama_alat': data['nama_alat'],
        'stok_total': data['stok_total'],
        'stok_tersedia': data['stok_tersedia'],
        'kondisi': data['kondisi'],
        'is_active': data['is_active'],
      };

      // Upload foto baru jika ada
      if (fotoFile != null) {
        final fileName = 'alat_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storagePath = 'alat_images/$fileName'; // ✅ Tambahkan folder path

        try {
          // ✅ Hapus foto lama jika ada
          final oldData = await _client
              .from('alat')
              .select('foto_url')
              .eq('id', id)
              .single();

          if (oldData['foto_url'] != null && oldData['foto_url'].isNotEmpty) {
            await _deleteFotoFromUrl(oldData['foto_url']);
          }

          // ✅ Upload foto baru ke bucket 'images'
          if (fotoFile is Uint8List) {
            await _client.storage
                .from('images')
                .uploadBinary(storagePath, fotoFile);
          } else if (fotoFile is File) {
            await _client.storage
                .from('images')
                .upload(storagePath, fotoFile);
          }

          updateData['foto_url'] =
              _client.storage.from('images').getPublicUrl(storagePath);
          debugPrint('✅ Foto berhasil diupload: ${updateData['foto_url']}');
        } catch (storageError) {
          debugPrint('❌ Storage error: $storageError');
        }
      }

      final response = await _client
          .from('alat')
          .update(updateData)
          .eq('id', id)
          .select();

      debugPrint('✅ Response update alat: $response');

      if (response.isEmpty) {
        throw Exception('Update gagal: ID alat tidak ditemukan');
      }
    } catch (e) {
      debugPrint('❌ Error updateAlat: $e');
      rethrow;
    }
  }

  /* ================= DELETE (SOFT) KATEGORI ================= */
  Future<void> deleteKategori(String id) async {
    try {
      debugPrint('🔵 deleteKategori dipanggil untuk ID: $id');

      // Soft delete kategori
      final kategoriResponse = await _client
          .from('kategori_alat')
          .update({'is_active': false})
          .eq('id', id)
          .select();

      debugPrint('✅ Response delete kategori: $kategoriResponse');

      // Soft delete semua alat dalam kategori
      final alatResponse = await _client
          .from('alat')
          .update({'is_active': false})
          .eq('kategori_id', id)
          .select();

      debugPrint('✅ Response delete alat terkait: $alatResponse');
    } catch (e) {
      debugPrint('❌ Error deleteKategori: $e');
      rethrow;
    }
  }

  /* ================= DELETE (SOFT) ALAT ================= */
  Future<void> deleteAlat(String id) async {
    try {
      debugPrint('🔵 deleteAlat dipanggil untuk ID: $id');

      final response = await _client
          .from('alat')
          .update({'is_active': false})
          .eq('id', id)
          .select();

      debugPrint('✅ Response delete alat: $response');

      if (response.isEmpty) {
        throw Exception('Delete gagal: ID alat tidak ditemukan');
      }
    } catch (e) {
      debugPrint('❌ Error deleteAlat: $e');
      rethrow;
    }
  }

  /* ================= HELPER - DELETE FOTO ================= */
  /// Helper method untuk menghapus foto dari storage berdasarkan URL
  Future<void> _deleteFotoFromUrl(String fotoUrl) async {
    try {
      // Extract path dari URL
      // Format URL: https://xxx.supabase.co/storage/v1/object/public/images/alat_images/filename.jpg
      final uri = Uri.parse(fotoUrl);
      final segments = uri.pathSegments;
      
      // Cari index 'images' dan ambil path setelahnya
      final imagesIndex = segments.indexOf('images');
      if (imagesIndex != -1 && imagesIndex < segments.length - 1) {
        final path = segments.sublist(imagesIndex + 1).join('/');
        await _client.storage.from('images').remove([path]);
        debugPrint('✅ Foto lama berhasil dihapus: $path');
      }
    } catch (e) {
      debugPrint('⚠️ Warning delete foto: $e');
      // Tidak throw error karena ini bukan operasi critical
    }
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
  Future<void> updatePeminjaman(String id, Map<String, dynamic> data) async {
    await _client.from('peminjaman').update(data).eq('id', id);
  }

  /// DELETE peminjaman
  Future<void> deletePeminjaman(String id) async {
    await _client.from('peminjaman').delete().eq('id', id);
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
    final res =
        await _client.from('pengembalian').insert(data).select().single();

    return res;
  }

  /// UPDATE pengembalian
  Future<void> updatePengembalian(String id, Map<String, dynamic> data) async {
    await _client.from('pengembalian').update(data).eq('id', id);
  }

  /// DELETE pengembalian
  Future<void> deletePengembalian(String id) async {
    await _client.from('pengembalian').delete().eq('id', id);
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