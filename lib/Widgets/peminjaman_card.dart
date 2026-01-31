import 'package:flutter/material.dart';
import '../models/peminjaman.dart';

class PeminjamanCard extends StatelessWidget {
  final Peminjaman peminjaman;
  final VoidCallback onLihat;
  final VoidCallback onEdit;
  final VoidCallback onHapus;

  const PeminjamanCard({
    super.key,
    required this.peminjaman,
    required this.onLihat,
    required this.onEdit,
    required this.onHapus,
  });

  Color _getStatusColor() {
    final status = peminjaman.status.toLowerCase();
    if (status == 'menunggu') return Colors.orange;
    if (status == 'disetujui') return Colors.blue;
    if (status == 'ditolak') return Colors.red;
    if (status == 'dipinjam') return Colors.blueAccent;
    if (status == 'dikembalikan') return Colors.green;
    return Colors.grey;
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
          Text(
            peminjaman.namaPeminjam,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Username: ${peminjaman.usernamePeminjam}',
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          if (peminjaman.namaPetugas != null) ...[
            const SizedBox(height: 4),
            Text(
              'Petugas: ${peminjaman.namaPetugas}',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                'Pinjam: ${peminjaman.tanggalPinjam.toString().substring(0, 10)}',
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.event_available, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                'Batas: ${peminjaman.batasPengembalian.toString().substring(0, 10)}',
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Alat yang dipinjam:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: peminjaman.detailAlat.map((detail) {
              return Chip(
                label: Text(
                  '${detail.namaAlat ?? 'Alat'} x${detail.jumlah}',
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 8),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  peminjaman.status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
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
        ],
      ),
    );
  }
}
