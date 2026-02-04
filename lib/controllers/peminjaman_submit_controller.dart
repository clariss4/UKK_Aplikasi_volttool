import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/database_service.dart';
import 'borrow_cart_controller.dart';

class PeminjamanSubmitController {
  final DatabaseService _db = DatabaseService();

  Future<bool> submit({
    required BuildContext context,
    required BorrowCartController cart,
    required DateTime batasPengembalian,
    required String kondisi,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final peminjamId = prefs.getString('userId');

      if (peminjamId == null) {
        throw Exception('User belum login');
      }

      // ================= INSERT PEMINJAMAN =================
      final peminjaman = await _db.insertPeminjaman({
        'peminjam_id': peminjamId,
        'tanggal_pinjam': DateTime.now().toIso8601String(),
        'batas_pengembalian': batasPengembalian.toIso8601String(),
        'status': 'menunggu',
      });

      final peminjamanId = peminjaman['id'];

      // ================= INSERT DETAIL + UPDATE STOK =================
      for (final item in cart.items) {
        await _db.insertPeminjamanDetail({
          'peminjaman_id': peminjamanId,
          'alat_id': item.id,
          'jumlah': item.qty,
        });

        await _db.kurangiStokAlat(
          alatId: item.id,
          jumlah: item.qty,
        );
      }

      // ================= CLEAR CART =================
      cart.clear();

      return true;
    } catch (e) {
      debugPrint('❌ Submit peminjaman gagal: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengajukan peminjaman'),
        ),
      );

      return false;
    }
  }
}
