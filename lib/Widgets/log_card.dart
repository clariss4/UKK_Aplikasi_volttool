// ==================== FILE: lib/widgets/log_card.dart ====================
import 'package:flutter/material.dart';
import '../models/log_aktivitas.dart';

class LogCard extends StatelessWidget {
  final LogAktivitas log;

  const LogCard({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getIconColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getIcon(), color: _getIconColor(), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          log.namaUser,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        log.getWaktuFormatted(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    log.aktivitas,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    final aktivitas = log.aktivitas.toLowerCase();
    if (aktivitas.contains('login') || aktivitas.contains('masuk')) {
      return Icons.login;
    } else if (aktivitas.contains('logout') || aktivitas.contains('keluar')) {
      return Icons.logout;
    } else if (aktivitas.contains('tambah') ||
        aktivitas.contains('menambahkan')) {
      return Icons.add_circle;
    } else if (aktivitas.contains('edit') ||
        aktivitas.contains('mengubah') ||
        aktivitas.contains('update')) {
      return Icons.edit;
    } else if (aktivitas.contains('hapus') || aktivitas.contains('menghapus')) {
      return Icons.delete;
    } else if (aktivitas.contains('pinjam') || aktivitas.contains('meminjam')) {
      return Icons.shopping_cart;
    } else if (aktivitas.contains('kembali') ||
        aktivitas.contains('mengembalikan')) {
      return Icons.assignment_return;
    } else if (aktivitas.contains('setuju') ||
        aktivitas.contains('menyetujui')) {
      return Icons.check_circle;
    } else if (aktivitas.contains('tolak') || aktivitas.contains('menolak')) {
      return Icons.cancel;
    } else {
      return Icons.info;
    }
  }

  Color _getIconColor() {
    final aktivitas = log.aktivitas.toLowerCase();
    if (aktivitas.contains('login') || aktivitas.contains('masuk')) {
      return Colors.green;
    } else if (aktivitas.contains('logout') || aktivitas.contains('keluar')) {
      return Colors.orange;
    } else if (aktivitas.contains('tambah') ||
        aktivitas.contains('menambahkan')) {
      return Colors.blue;
    } else if (aktivitas.contains('edit') ||
        aktivitas.contains('mengubah') ||
        aktivitas.contains('update')) {
      return const Color(0xFFFF8C42);
    } else if (aktivitas.contains('hapus') || aktivitas.contains('menghapus')) {
      return Colors.red;
    } else if (aktivitas.contains('pinjam') || aktivitas.contains('meminjam')) {
      return Colors.purple;
    } else if (aktivitas.contains('kembali') ||
        aktivitas.contains('mengembalikan')) {
      return Colors.teal;
    } else if (aktivitas.contains('setuju') ||
        aktivitas.contains('menyetujui')) {
      return Colors.green;
    } else if (aktivitas.contains('tolak') || aktivitas.contains('menolak')) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}
