import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/database_service.dart';

class PengembalianProcessController {
  final _client = Supabase.instance.client;
  final _db = DatabaseService();

  /// PROSES PENGEMBALIAN
  /// - insert pengembalian
  /// - tambah stok
  /// - update status peminjaman
  Future<void> prosesPengembalian({
    required String peminjamanId,
    required String petugasId,
    required String kondisi,
  }) async {
    /// insert pengembalian
    await _db.insertPengembalian({
      'peminjaman_id': peminjamanId,
      'petugas_id': petugasId,
      'kondisi': kondisi,
    });

    /// ambil detail alat
    final details = await _client
        .from('peminjaman_detail')
        .select()
        .eq('peminjaman_id', peminjamanId);

    if (details.isEmpty) {
      throw Exception('Detail peminjaman tidak ditemukan');
    }

    /// LOOP → tambah stok
    for (final d in details) {
      await _db.tambahStokAlat(
        alatId: d['alat_id'],
        jumlah: d['jumlah'],
      );
    }

    /// update status peminjaman
    await _db.updatePeminjaman(peminjamanId, {
      'status': 'dikembalikan',
    });
  }
}
