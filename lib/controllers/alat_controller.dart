// ==================== FILE: lib/controllers/alat_controller.dart ====================

import 'dart:io';
import 'package:flutter/material.dart';
import '../models/alat.dart';
import '../services/database_service.dart';

class AlatController extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Alat> alatList = [];
  bool isLoading = false;

  /* ================= LOAD ALAT ================= */
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

  /* ================= TAMBAH ALAT ================= */
  Future<void> tambahAlat({
    required String kategoriId,
    required String namaAlat,
    required int stokTotal,
    required String kondisi,
    File? fotoFile,
  }) async {
    try {
      final data = {
        'kategori_id': kategoriId,
        'nama_alat': namaAlat,
        'stok_total': stokTotal,
        'stok_tersedia': stokTotal,
        'kondisi': kondisi,
        'is_active': true,
      };

      await _db.insertAlat(data, fotoFile: fotoFile);
      await loadAlat();
    } catch (e) {
      debugPrint('Error insert alat: $e');
      rethrow;
    }
  }

  /* ================= UPDATE ALAT ================= */
  Future<void> updateAlat({
    required String id,
    required String kategoriId,
    required String namaAlat,
    required int stokTotal,
    required String kondisi,
    File? fotoFile,
  }) async {
    try {
      final data = {
        'kategori_id': kategoriId,
        'nama_alat': namaAlat,
        'stok_total': stokTotal,
        'kondisi': kondisi,
      };

      await _db.updateAlat(id, data, fotoFile: fotoFile);
      await loadAlat();
    } catch (e) {
      debugPrint('Error update alat: $e');
      rethrow;
    }
  }

  /* ================= DELETE ALAT ================= */
  Future<void> deleteAlat(String id) async {
    try {
      await _db.deleteAlat(id);
      await loadAlat();
    } catch (e) {
      debugPrint('Error delete alat: $e');
      rethrow;
    }
  }
}