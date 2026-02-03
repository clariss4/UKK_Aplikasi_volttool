import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeminjamanList extends StatelessWidget {
  final List<Map<String, String>> items;

  const PeminjamanList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];

        final String rawStatus = item["status"] ?? "";
        final String status = rawStatus.trim().toLowerCase();

        return SizedBox(
          width: double.infinity,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ======================
                /// KONTEN KIRI
                /// ======================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// NAMA PEMINJAM
                      Text(
                        item["peminjam"] ?? "-",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// DESKRIPSI ALAT
                      Text(
                        item["deskripsiAlat"] ?? "-",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// TANGGAL
                      Text(
                        "Pinjam: ${item["tanggalPinjam"] ?? "-"}",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Batas: ${item["batasPengembalian"] ?? "-"}",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                /// ======================
                /// STATUS KANAN
                /// ======================
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusBgColor(status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    rawStatus,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _statusTextColor(status),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// ======================
  /// WARNA STATUS
  /// ======================
  Color _statusTextColor(String status) {
    switch (status) {
      case "menunggu":
      case "meminjam":
        return Colors.orange;
      case "dikembalikan":
        return Colors.green;
      case "terlambat":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case "menunggu":
      case "meminjam":
        return Colors.yellow.shade200;
      case "dikembalikan":
        return Colors.green.shade200;
      case "terlambat":
        return Colors.red.shade200;
      default:
        return Colors.grey.shade300;
    }
  }
}
