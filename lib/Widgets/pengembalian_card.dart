import 'package:flutter/material.dart';

class PengembalianCard extends StatelessWidget {
  final String namaLengkap;
  final String username;
  final String petugas;
  final String tanggalPinjam;
  final String dikembalikan;
  final String kondisi;
  final String? denda;
  final String status;
  final Color statusColor;
  final VoidCallback onEditPressed;

  const PengembalianCard({
    Key? key,
    required this.namaLengkap,
    required this.username,
    required this.petugas,
    required this.tanggalPinjam,
    required this.dikembalikan,
    required this.kondisi,
    this.denda,
    required this.status,
    required this.statusColor,
    required this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(namaLengkap, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Username: $username', style: TextStyle(color: Colors.grey[700])),
          Text('Petugas: $petugas', style: TextStyle(color: Colors.grey[700])),
          Text('Tanggal pinjam: $tanggalPinjam', style: TextStyle(color: Colors.grey[700])),
          Text('Dikembalikan: $dikembalikan', style: TextStyle(color: Colors.grey[700])),
          Text('Kondisi: $kondisi', style: TextStyle(color: Colors.grey[700])),
          if (denda != null) ...[
            const SizedBox(height: 8),
            Text('Denda: $denda', style: TextStyle(color: Colors.grey[600])),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Status:', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Text(status, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                    if (status == 'Hilang' || status == 'Terlambat')
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.warning, color: Colors.white, size: 14),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEditPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFD67A3E), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: const [
                      Text('Edit', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                      SizedBox(width: 4),
                      Icon(Icons.edit, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
