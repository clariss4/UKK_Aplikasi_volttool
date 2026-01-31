import 'package:flutter/material.dart';
import '../models/pengembalian.dart';

class PengembalianManajemenCard extends StatelessWidget {
  final Pengembalian pengembalian;
  final VoidCallback onLihat;
  final VoidCallback onEdit;
  final VoidCallback onHapus;

  const PengembalianManajemenCard({
    super.key,
    required this.pengembalian,
    required this.onLihat,
    required this.onEdit,
    required this.onHapus,
  });

  Color _getStatusColor() {
    if (pengembalian.terlambat) return Colors.redAccent;
    switch (pengembalian.kondisi.toLowerCase()) {
      case 'baik':
        return Colors.green;
      case 'rusak':
        return Colors.orange;
      case 'hilang':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pengembalian.namaPetugas != null) ...[
            Text(
              'Petugas: ${pengembalian.namaPetugas}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
          ],
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                'Dikembalikan: ${pengembalian.tanggalKembali.toString().substring(0, 10)}',
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Kondisi: ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  pengembalian.kondisi.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (pengembalian.terlambat) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Terlambat',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
          if (pengembalian.denda != null) ...[
            const SizedBox(height: 8),
            Text(
              'Denda: ${pengembalian.denda!.jenisDenda} - Rp ${pengembalian.denda!.jumlahDenda.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.visibility,
                  color: Color(0xFFFB923C),
                  size: 22,
                ),
                onPressed: onLihat,
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Color(0xFFFB923C),
                  size: 22,
                ),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 22,
                ),
                onPressed: onHapus,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
