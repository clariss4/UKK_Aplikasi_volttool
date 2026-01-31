// lib/controllers/pengembalian_controller.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pengembalian.dart';
import '../services/database_service.dart';

class PengembalianController extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<Pengembalian> _pengembalianList = [];
  List<Pengembalian> get pengembalianList => _pengembalianList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Stream realtime (dipakai di screen)
  Stream<List<Pengembalian>> get streamPengembalian {
    return _db.streamPengembalian().map((data) {
      return data.map((json) => Pengembalian.fromJson(json)).toList();
    });
  }

  // Load data awal
  Future<void> loadPengembalian() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _db.getPengembalian();
      _pengembalianList = response.map((json) => Pengembalian.fromJson(json)).toList();
    } catch (e) {
      _error = 'Gagal memuat pengembalian: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Update kondisi (dipanggil dari dialog)
  Future<void> updateKondisi(String id, String kondisiBaru) async {
    try {
      await _db.updatePengembalian(id, {'kondisi': kondisiBaru});
      await loadPengembalian();
      notifyListeners();
    } catch (e) {
      _error = 'Gagal update kondisi: $e';
      notifyListeners();
    }
  }

  // Hapus pengembalian
  Future<void> hapusPengembalian(String id) async {
    try {
      await _db.deletePengembalian(id);
      await loadPengembalian();
      notifyListeners();
    } catch (e) {
      _error = 'Gagal hapus pengembalian: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<dynamic> tambahPengembalian({required String peminjamanId, required String petugasId, required DateTime tanggalKembali, required String kondisi, required DateTime batasPengembalian, required BuildContext context}) async {}
}