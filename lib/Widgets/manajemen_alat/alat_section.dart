import 'package:apk_peminjaman/Widgets/manajemen_alat/alat_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/alat.dart';


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
      return const Center(child: CircularProgressIndicator());
    }

    if (alatList.isEmpty) {
      return Center(
        child: Text(
          'Alat tidak ditemukan',
          style: GoogleFonts.inter(color: Colors.grey),
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