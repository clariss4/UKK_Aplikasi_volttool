import 'dart:io' show File;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import '../models/alat.dart';
import '../services/database_service.dart';

class AlatController extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Alat> alatList = [];
  bool isLoading = false;

  // ================= LOAD ALAT =================
  Future<void> loadAlat() async {
    isLoading = true;
    notifyListeners();

    try {
      alatList = await _db.getAlat();
    } catch (e) {
      debugPrint('Error loading alat: $e');
      alatList = [];
    }

    isLoading = false;
    notifyListeners();
  }

  // ================= TAMBAH ALAT =================
  Future<void> tambahAlat({
    required String kategoriId,
    required String namaAlat,
    required int stokTotal,
    required String kondisi,
    dynamic fotoFile, // bisa File (mobile) atau Uint8List (web)
  }) async {
    try {
      final data = {
        'kategori_id': kategoriId,
        'nama_alat': namaAlat,
        'stok_total': stokTotal,
        'stok_tersedia': stokTotal,
        'kondisi': kondisi,
      };

      await _db.insertAlat(data, fotoFile: fotoFile);
      await loadAlat();
    } catch (e) {
      debugPrint('Error menambah alat: $e');
      rethrow;
    }
  }

  // ================= UPDATE ALAT =================
  Future<void> updateAlat({
    required String id,
    required String kategoriId,
    required String namaAlat,
    required int stokTotal,
    required String kondisi,
    dynamic fotoFile, // bisa File (mobile) atau Uint8List (web)
  }) async {
    try {
      final data = {
        'kategori_id': kategoriId,
        'nama_alat': namaAlat,
        'stok_total': stokTotal,
        'kondisi': kondisi,
        // stok_tersedia tidak diubah saat update (sesuai logika umum)
      };

      await _db.updateAlat(id, data, fotoFile: fotoFile);
      await loadAlat();
    } catch (e) {
      debugPrint('Error mengupdate alat: $e');
      rethrow;
    }
  }

  // ================= DELETE ALAT =================
  Future<void> deleteAlat(String id) async {
    try {
      await _db.deleteAlat(id);
      await loadAlat();
    } catch (e) {
      debugPrint('Error menghapus alat: $e');
      rethrow;
    }
  }
}