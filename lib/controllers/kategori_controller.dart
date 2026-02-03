import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/kategori.dart';
import '../services/database_service.dart';

class KategoriController extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<Kategori> kategoriList = [];
  bool isLoading = true;
  StreamSubscription<List<Kategori>>? _kategoriSub;

  KategoriController() {
    _startListening();
  }

  void _startListening() {
    _kategoriSub?.cancel();
    isLoading = true;
    notifyListeners();

    _kategoriSub = _db.streamKategoriAll().listen((data) {
      kategoriList = data;
      isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint('Stream kategori error: $e');
      isLoading = false;
      notifyListeners();
    });
  }

  // ================= INSERT =================
  Future<void> tambahKategori(String namaKategori) async {
    try {
      final kategori = Kategori(id: '', namaKategori: namaKategori);
      await _db.insertKategori(kategori.toInsertMap());
      // Stream otomatis update → UI tidak perlu reload
    } catch (e) {
      debugPrint('Error tambah kategori: $e');
      rethrow;
    }
  }

  // ================= UPDATE =================
  Future<void> updateKategori(String id, String namaKategori) async {
    try {
      final kategori = Kategori(id: id, namaKategori: namaKategori);
      await _db.updateKategori(id, kategori.toUpdateMap());
      // Stream otomatis update → UI tidak perlu reload
    } catch (e) {
      debugPrint('Error update kategori: $e');
      rethrow;
    }
  }

  // ================= DELETE (SOFT) =================
  Future<void> deleteKategori(String id) async {
    try {
      await _db.deleteKategori(id);
      // Stream otomatis update → UI tidak perlu reload
    } catch (e) {
      debugPrint('Error delete kategori: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _kategoriSub?.cancel();
    super.dispose();
  }
}
