// lib/controllers/peminjaman_controller.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/peminjaman.dart';
import '../services/database_service.dart';

class PeminjamanController extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<Peminjaman> _peminjamanList = [];
  List<Peminjaman> get peminjamanList => _peminjamanList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Stream realtime (dipakai di screen)
  Stream<List<Peminjaman>> get streamPeminjaman {
    return _db.streamPeminjaman().map((data) {
      return data.map((json) => Peminjaman.fromJson(json)).toList();
    });
  }

  // Load data awal (dipanggil di initState screen)
  Future<void> loadPeminjaman() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _db.getPeminjaman();
      _peminjamanList = response.map((json) => Peminjaman.fromJson(json)).toList();
    } catch (e) {
      _error = 'Gagal memuat peminjaman: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Update status (dipanggil dari dialog)
  Future<void> updateStatus(String id, String statusBaru) async {
    try {
      await _db.updatePeminjaman(id, {'status': statusBaru});
      await loadPeminjaman(); // refresh list
      notifyListeners();
    } catch (e) {
      _error = 'Gagal update status: $e';
      notifyListeners();
    }
  }

  // Hapus peminjaman (dipanggil dari card)
  Future<void> hapusPeminjaman(String id) async {
    try {
      await _db.deletePeminjaman(id);
      await loadPeminjaman(); // refresh list
      notifyListeners();
    } catch (e) {
      _error = 'Gagal hapus peminjaman: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}