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
        .from('kategori_alat')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((rows) => rows.map((e) => Kategori.fromJson(e)).toList());
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
    try {
      // ✅ 1. Update kategori
      final response = await _client
          .from('kategori_alat')
          .update({
            'nama_kategori': data['nama_kategori'],
            'is_active': data['is_active'],
          })
          .eq('id', id)
          .select();

      debugPrint('✅ Update kategori berhasil: $response');

      // ✅ 2. Sinkronkan status alat (PERBAIKAN DARI BUG 'isactive')
      if (data['is_active'] == false) {
        await _client
            .from('alat')
            .update({'is_active': false}) // ✅ BOOLEAN, bukan string 'isactive'
            .eq('kategori_id', id);

        debugPrint('✅ Status alat dalam kategori berhasil disinkronkan');
      }
    } catch (e) {
      debugPrint('❌ Error updateKategori: $e');
      debugPrint('❌ Error details: ${e.toString()}');
      rethrow;
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
      // ✅ 1. Nonaktifkan kategori
      final response = await _client
          .from('kategori_alat')
          .update({'is_active': false})
          .eq('id', id)
          .select();

      debugPrint('✅ Soft delete kategori berhasil: $response');

      // ✅ 2. CASCADE: Nonaktifkan SEMUA alat dalam kategori ini
      await _client
          .from('alat')
          .update({'is_active': false})
          .eq('kategori_id', id);

      debugPrint('✅ Semua alat dalam kategori berhasil dinonaktifkan');
    } catch (e) {
      debugPrint('❌ Error deleteKategori: $e');
      debugPrint('❌ Error details: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> deleteAlat(String id) async {
    await _client.from('alat').update({'is_active': false}).eq('id', id);
  }

  // ================= PEMINJAMAN =================

  Stream<List<Map<String, dynamic>>> streamPeminjaman() {
    return _client
        .from('peminjaman')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  Future<List<Map<String, dynamic>>> getPeminjaman() async {
    final response = await _client
        .from('peminjaman')
        .select('''
          *,
          peminjam:users!fk_peminjam (nama_lengkap, username),          // pakai fk_peminjam
          petugas:users!fk_petugas (nama_lengkap)                       // kalau petugas_id punya constraint fk_petugas
        ''')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getPeminjamanById(String id) async {
    final response = await _client
        .from('peminjaman')
        .select('''
          *,
          peminjam:users!fk_peminjam (nama_lengkap, username),
          petugas:users!fk_petugas (nama_lengkap),
          peminjaman_detail (*, alat (nama_alat, foto_url))
        ''')
        .eq('id', id)
        .maybeSingle();
    return response;
  }

  Future<void> insertPeminjaman({
    required Map<String, dynamic> peminjamanData,
    required List<Map<String, dynamic>> detailData,
  }) async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePeminjaman(String id, Map<String, dynamic> data) async {
    await _client.from('peminjaman').update(data).eq('id', id);
  }

  Future<void> deletePeminjaman(String id) async {
    await _client.from('peminjaman_detail').delete().eq('peminjaman_id', id);
    await _client.from('peminjaman').delete().eq('id', id);
  }

  // ================= PENGEMBALIAN =================

  Stream<List<Map<String, dynamic>>> streamPengembalian() {
    return _client
        .from('pengembalian')
        .stream(primaryKey: ['id'])
        .order('tanggal_kembali', ascending: false);
  }

  Future<List<Map<String, dynamic>>> getPengembalian() async {
    final response = await _client
        .from('pengembalian')
        .select('''
          *,
          petugas:users!fk_petugas_kembali (nama_lengkap),             // pakai fk_petugas_kembali
          peminjaman (
            *,
            peminjam:users!fk_peminjam (nama_lengkap, username)        // pakai fk_peminjam
          ),
          denda (*)
        ''')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getPengembalianById(String id) async {
    final response = await _client
        .from('pengembalian')
        .select('''
            *,
            petugas:users!petugas_id (nama_lengkap),
            peminjaman (*),
            denda (*)
          ''')
        .eq('id', id)
        .maybeSingle();
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
