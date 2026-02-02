import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:apk_peminjaman/Widgets/alat_form_dialog.dart';
import 'package:apk_peminjaman/Widgets/kateogri_form_dialog.dart';
import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:apk_peminjaman/Widgets/alat_card.dart';
import 'package:apk_peminjaman/models/alat.dart';
import 'package:apk_peminjaman/models/kategori.dart';
import 'package:apk_peminjaman/services/database_service.dart';

class ManajemenAlatPage extends StatefulWidget {
  const ManajemenAlatPage({super.key});

  @override
  State<ManajemenAlatPage> createState() => _ManajemenAlatPageState();
}

class _ManajemenAlatPageState extends State<ManajemenAlatPage> {
  final DatabaseService _db = DatabaseService();

  final searchController = TextEditingController();

  List<Alat> alatListFull = [];
  List<Kategori> kategoriList = [];

  int selectedFilterIndex = 0;
  bool isLoading = true;

  StreamSubscription<List<Alat>>? alatSub;
  StreamSubscription<List<Kategori>>? kategoriSub;

  @override
  void initState() {
    super.initState();

    // 🔹 STREAM ALAT
    alatSub = _db.streamAlat().listen((data) {
      setState(() {
        alatListFull = data;
        isLoading = false;
      });
    });

    // 🔹 STREAM KATEGORI
    kategoriSub = _db.streamKategori().listen((data) {
      setState(() {
        kategoriList = data;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    alatSub?.cancel();
    kategoriSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ================= FILTER KATEGORI =================
    List<Alat> alatList = List.from(alatListFull);
    if (selectedFilterIndex > 0 && kategoriList.isNotEmpty) {
      final kategoriId = kategoriList[selectedFilterIndex - 1].id;
      alatList = alatList.where((a) => a.kategoriId == kategoriId).toList();
    }

    // ================= FILTER SEARCH =================
    final keyword = searchController.text.trim().toLowerCase();
    if (keyword.isNotEmpty) {
      alatList = alatList
          .where((a) => a.namaAlat.toLowerCase().contains(keyword))
          .toList();
    }

    return Scaffold(
      drawer: AppDrawer(currentPage: 'Manajemen Alat'),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          _buildKategoriHeader(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : alatList.isEmpty
                    ? Center(
                        child: Text(
                          'Alat tidak ditemukan',
                          style: GoogleFonts.inter(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: alatList.length,
                        itemBuilder: (context, index) {
                          return AlatCard(
                            alat: alatList[index],
                            onEdit: () async {
                              final result =
                                  await showDialog<Map<String, dynamic>>(
                                context: context,
                                builder: (_) => AlatFormDialog(
                                  alat: alatList[index],
                                  kategoriList: kategoriList,
                                ),
                              );

                              if (result != null) {
                                await _db.updateAlat(
                                  alatList[index].id,
                                  {
                                    'kategori_id': result['kategoriId'],
                                    'nama_alat': result['namaAlat'],
                                    'stok_total': result['stokTotal'],
                                    'stok_tersedia': result['stokTersedia'],
                                    'kondisi': result['kondisi'],
                                    'is_active': true,
                                  },
                                  fotoFile: result['fotoFile'],
                                );
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // ================= APP BAR =================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFF8C42),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      toolbarHeight: 110,
      title: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manajemen',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            Text('Alat & Kategori',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ================= SEARCH BAR =================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.inter(),
              decoration: InputDecoration(
                hintText: 'Cari alat...',
                hintStyle: GoogleFonts.inter(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.grey, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.grey, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.grey, width: 1.8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (_) => AlatFormDialog(kategoriList: kategoriList),
              );

              if (result != null) {
                await _db.insertAlat(
                  {
                    'kategori_id': result['kategoriId'],
                    'nama_alat': result['namaAlat'],
                    'stok_total': result['stokTotal'],
                    'kondisi': result['kondisi'],
                    'is_active': true,
                  },
                  fotoFile: result['fotoFile'],
                );
              }
            },
            icon: const Icon(Icons.add, size: 18, color: Colors.white),
            label: Text(
              'Alat',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C42),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILTER CHIP =================
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
                  side:
                      const BorderSide(color: Color(0xFFFF8C42), width: 1),
                ),
                onSelected: (_) async {
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (_) => const KategoriFormDialog(),
                  );

                  if (result != null) {
                    await _db.insertKategori({
                      'nama_kategori': result['nama'],
                      'is_active': true,
                    });
                  }
                },
              ),
            );
          }

          final kategori = kategoriList[index - 1];
          final isSelected = selectedFilterIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                kategori.namaKategori,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color(0xFFFF8C42) : Colors.white,
                ),
              ),
              selected: isSelected,
              showCheckmark: false,
              backgroundColor: const Color(0xFFFF8C42),
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: const Color(0xFFFF8C42),
                  width: isSelected ? 1.5 : 0,
                ),
              ),
              onSelected: (_) {
                setState(() {
                  selectedFilterIndex = index;
                });
              },
            ),
          );
        },
      ),
    );
  }

  // ================= HEADER =================
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
          if (kategori != null)
            IconButton(
              icon: const Icon(Icons.edit),
              color: const Color(0xFFFF8C42),
              onPressed: () async {
                final result = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (_) => KategoriFormDialog(kategori: kategori),
                );

                if (result != null) {
                  await _db.updateKategori(kategori.id, {
                    'nama_kategori': result['nama'],
                    'is_active': true,
                  });
                }
              },
            ),
        ],
      ),
    );
  }
}
