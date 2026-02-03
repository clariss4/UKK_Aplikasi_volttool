import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/alat.dart';

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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Foto Alat
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  image: alat.fotoUrl != null && alat.fotoUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(alat.fotoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: alat.fotoUrl == null || alat.fotoUrl!.isEmpty
                    ? Icon(Icons.image_not_supported,
                        color: Colors.grey.shade400)
                    : null,
              ),
              const SizedBox(width: 12),

              // Info Alat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alat.namaAlat,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildBadge(
                          'Stok: ${alat.stokTersedia}/${alat.stokTotal}',
                          Colors.blue.shade50,
                          Colors.blue.shade700,
                        ),
                        const SizedBox(width: 8),
                        _buildBadge(
                          alat.kondisi.toUpperCase(),
                          alat.kondisi == 'baik'
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          alat.kondisi == 'baik'
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Badge & Icon
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: alat.isActive
                          ? Colors.green.shade50
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      alat.isActive ? 'Aktif' : 'Non-Aktif',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: alat.isActive
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.edit,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}