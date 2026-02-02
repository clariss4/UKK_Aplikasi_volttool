import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/alat.dart';

class AlatCard extends StatelessWidget {
  final Alat alat;
  final VoidCallback onEdit;

  const AlatCard({
    super.key,
    required this.alat,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: alat.fotoUrl != null
                ? Image.network(
                    alat.fotoUrl!,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 72,
                    height: 72,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.build),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alat.namaAlat,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stok: ${alat.stokTersedia}/${alat.stokTotal}',
                  style: GoogleFonts.inter(fontSize: 13),
                ),
                Text(
                  'Kondisi: ${alat.kondisi}',
                  style: GoogleFonts.inter(fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            color: Color(0xFFFF8C42),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}