import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeminjamanList extends StatelessWidget {
  final List<Map<String, String>> items;

  const PeminjamanList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(item["namaAlat"] ?? "",
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            subtitle: Text(
              "Peminjam: ${item["peminjam"]}\nTanggal: ${item["tanggalPinjam"]}",
              style: const TextStyle(color: Colors.black54),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor(item["status"] ?? ""),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item["status"] ?? "",
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        );
      }),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Menunggu":
        return Colors.yellow.shade700;
      case "Dikembalikan":
        return Colors.green.shade600;
      case "Terlambat":
        return Colors.red.shade600;
      case "Dipinjam":
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade400;
    }
  }
}
