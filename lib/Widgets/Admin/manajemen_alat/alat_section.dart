import 'package:apk_peminjaman/Widgets/Admin/manajemen_alat/alat_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/alat.dart';

class AlatSection extends StatelessWidget {
  final bool isLoading;
  final List<Alat> alatList;
  final Function(Alat) onEditAlat;

  const AlatSection({
    super.key,
    required this.isLoading,
    required this.alatList,
    required this.onEditAlat,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8C42)),
        ),
      );
    }

    if (alatList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Alat tidak ditemukan',
              style: GoogleFonts.inter(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan alat baru atau ubah filter',
              style: GoogleFonts.inter(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: alatList.length,
      itemBuilder: (context, index) {
        return AlatCard(
          alat: alatList[index],
          onEdit: () => onEditAlat(alatList[index]),
        );
      },
    );
  }
}