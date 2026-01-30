// ==================== FILE: lib/controllers/kategori_controller.dart ====================

import 'package:flutter/material.dart';
import '../models/kategori.dart';
import '../services/database_service.dart';

class KategoriController extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Kategori> kategoriList = [];
  bool isLoading = false;

  /* ================= LOAD KATEGORI ================= */
  Future<void> loadKategori() async {
    isLoading = true;
    notifyListeners();

    try {
      kategoriList = await _db.getKategori();
    } catch (e) {
      debugPrint('Error loading kategori: $e');
      kategoriList = [];
    }

    isLoading = false;
    notifyListeners();
  }

  /* ================= TAMBAH KATEGORI ================= */
  Future<void> tambahKategori(String nama) async {
    try {
      await _db.insertKategori({
        'nama_kategori': nama,
        'is_active': true,
      });
      await loadKategori();
    } catch (e) {
      debugPrint('Error insert kategori: $e');
      rethrow;
    }
  }

  /* ================= UPDATE KATEGORI ================= */
  Future<void> updateKategori(String id, String nama) async {
    try {
      await _db.updateKategori(id, {
        'nama_kategori': nama,
      });
      await loadKategori();
    } catch (e) {
      debugPrint('Error update kategori: $e');
      rethrow;
    }
  }

  /* ================= DELETE KATEGORI ================= */
  Future<void> deleteKategori(String id) async {
    try {
      await _db.deleteKategori(id);
      await loadKategori();
    } catch (e) {
      debugPrint('Error delete kategori: $e');
      rethrow;
    }
  }
}