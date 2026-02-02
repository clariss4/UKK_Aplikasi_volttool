import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/alat.dart';
import '../services/database_service.dart';

class AlatController extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<Alat> alatList = [];
  bool isLoading = true;
  StreamSubscription<List<Alat>>? _alatSub;

  AlatController() {
    _startListening();
  }

  void _startListening() {
    _alatSub?.cancel();
    isLoading = true;
    notifyListeners();

    _alatSub = _db.streamAlat().listen((data) {
      alatList = data;
      isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint('Stream alat error: $e');
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> tambahAlat({
    required String kategoriId,
    required String namaAlat,
    required int stokTotal,
    required String kondisi,
    dynamic fotoFile,
  }) async {
    try {
      final alat = Alat(
        id: '',
        kategoriId: kategoriId,
        namaAlat: namaAlat,
        stokTotal: stokTotal,
        stokTersedia: stokTotal,
        kondisi: kondisi,
        isActive: true,
      );
      await _db.insertAlat(alat.toInsertMap(), fotoFile: fotoFile);

      // 🔹 Tidak perlu loadAlat() lagi
    } catch (e) {
      debugPrint('Error tambah alat: $e');
      rethrow;
    }
  }

  Future<void> updateAlat({
    required String id,
    required String kategoriId,
    required String namaAlat,
    required int stokTotal,
    required int stokTersedia,
    required String kondisi,
    bool isActive = true,
    dynamic fotoFile,
  }) async {
    try {
      final alat = Alat(
        id: id,
        kategoriId: kategoriId,
        namaAlat: namaAlat,
        stokTotal: stokTotal,
        stokTersedia: stokTersedia,
        kondisi: kondisi,
        isActive: isActive,
      );

      await _db.updateAlat(id, alat.toUpdateMap(), fotoFile: fotoFile);

      // 🔹 Stream akan otomatis update → UI rebuild
    } catch (e) {
      debugPrint('Error update alat: $e');
      rethrow;
    }
  }

  Future<void> deleteAlat(String id) async {
    try {
      await _db.deleteAlat(id);
      // 🔹 Stream otomatis akan update
    } catch (e) {
      debugPrint('Error delete alat: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _alatSub?.cancel();
    super.dispose();
  }
}
