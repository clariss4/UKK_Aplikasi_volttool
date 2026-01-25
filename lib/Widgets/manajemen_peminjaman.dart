import 'package:flutter/material.dart';

class ManajemenPeminjamanList extends StatelessWidget {
  final List<Map<String, String>> items;

  const ManajemenPeminjamanList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text('Belum ada peminjaman hari ini'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final peminjaman = items[index];
        final status = peminjaman['status'] ?? 'Dipinjam';
        Color statusColor;

        switch (status.toLowerCase()) {
          case 'dipinjam':
            statusColor = Colors.blue.shade300;
            break;
          case 'kembali':
            statusColor = Colors.green.shade400;
            break;
          case 'terlambat':
            statusColor = Colors.red.shade400;
            break;
          default:
            statusColor = Colors.grey.shade400;
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(peminjaman['namaAlat'] ?? '-',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                '${peminjaman['peminjam'] ?? '-'} • ${peminjaman['tanggalPinjam'] ?? '-'}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
