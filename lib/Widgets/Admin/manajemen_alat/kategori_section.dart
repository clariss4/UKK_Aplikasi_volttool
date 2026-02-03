import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/kategori.dart';

class KategoriSection extends StatelessWidget {
  final List<Kategori> kategoriList;
  final int selectedFilterIndex;
  final Function(int) onFilterSelected;
  final VoidCallback onTambahKategori;
  final VoidCallback? onEditKategori;

  const KategoriSection({
    super.key,
    required this.kategoriList,
    required this.selectedFilterIndex,
    required this.onFilterSelected,
    required this.onTambahKategori,
    this.onEditKategori,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterChips(),
        _buildKategoriHeader(),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kategoriList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: const Icon(Icons.add, size: 16, color: Colors.white),
                label: Text(
                  'Tambah Kategori',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: const Color(0xFFFF8C42),
                showCheckmark: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: Color(0xFFFF8C42), width: 1),
                ),
                onSelected: (_) => onTambahKategori(),
              ),
            );
          }

          final kategori = kategoriList[index - 1];
          final isSelected = selectedFilterIndex == index;

          final chipColor = kategori.isActive
              ? const Color(0xFFFF8C42)
              : Colors.grey.shade400;
          final textColor = isSelected
              ? (kategori.isActive
                    ? const Color(0xFFFF8C42)
                    : Colors.grey.shade600)
              : Colors.white;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                kategori.namaKategori,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  decoration: kategori.isActive 
                      ? null 
                      : TextDecoration.lineThrough,
                ),
              ),
              selected: isSelected,
              showCheckmark: false,
              backgroundColor: chipColor,
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: chipColor, width: isSelected ? 1.5 : 0),
              ),
              onSelected: (_) => onFilterSelected(index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKategoriHeader() {
    final kategori = selectedFilterIndex > 0 && kategoriList.isNotEmpty
        ? kategoriList[selectedFilterIndex - 1]
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              kategori?.namaKategori ?? 'Semua Alat',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (kategori != null && onEditKategori != null)
            IconButton(
              icon: const Icon(Icons.edit),
              color: const Color(0xFFFF8C42),
              onPressed: onEditKategori,
            ),
        ],
      ),
    );
  }
}