import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/database_service.dart';

class PeminjamanApprovalController {
  final _client = Supabase.instance.client;
  final _db = DatabaseService();

  /// SETUJUI PEMINJAMAN
  /// - kurangi stok
  /// - ubah status → dipinjam
  Future<void> setujuiPeminjaman(String peminjamanId) async {
    /// ambil detail alat
    final details = await _client
        .from('peminjaman_detail')
        .select()
        .eq('peminjaman_id', peminjamanId);

    if (details.isEmpty) {
      throw Exception('Detail peminjaman tidak ditemukan');
    }

    /// LOOP → kurangi stok
    for (final d in details) {
      await _db.kurangiStokAlat(
        alatId: d['alat_id'],
        jumlah: d['jumlah'],
      );
    }

    /// update status peminjaman
    await _db.updatePeminjaman(peminjamanId, {
      'status': 'dipinjam',
    });
  }

  /// TOLAK PEMINJAMAN
  Future<void> tolakPeminjaman(String peminjamanId) async {
    await _db.updatePeminjaman(peminjamanId, {
      'status': 'ditolak',
    });
  }
}
