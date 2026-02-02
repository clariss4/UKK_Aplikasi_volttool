import 'dart:async';
import 'package:apk_peminjaman/Widgets/manajemen_alat/alat_form_dialog.dart';
import 'package:apk_peminjaman/Widgets/manajemen_alat/kateogri_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:apk_peminjaman/Widgets/manajemen_alat/search_bar_section.dart';
import 'package:apk_peminjaman/Widgets/manajemen_alat/kategori_section.dart';
import 'package:apk_peminjaman/Widgets/manajemen_alat/alat_section.dart';
import 'package:apk_peminjaman/Widgets/main_drawer.dart';
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
    _initStreams();
  }

  void _initStreams() {
    // Stream Alat
    alatSub = _db.streamAlatAll().listen((data) {
      if (mounted) {
        setState(() {
          alatListFull = data;
          isLoading = false;
        });
      }
    });

    // Stream Kategori
    kategoriSub = _db.streamKategoriAll().listen((data) {
      if (mounted) {
        setState(() {
          kategoriList = data;
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    alatSub?.cancel();
    kategoriSub?.cancel();
    super.dispose();
  }

  // ================= FILTER DATA =================
  List<Alat> _getFilteredAlatList() {
    List<Alat> alatList = List.from(alatListFull);

    // Filter by kategori
    if (selectedFilterIndex > 0 && kategoriList.isNotEmpty) {
      final kategoriId = kategoriList[selectedFilterIndex - 1].id;
      alatList = alatList.where((a) => a.kategoriId == kategoriId).toList();
    }

    // Filter by search
    final keyword = searchController.text.trim().toLowerCase();
    if (keyword.isNotEmpty) {
      alatList = alatList
          .where((a) => a.namaAlat.toLowerCase().contains(keyword))
          .toList();
    }

    return alatList;
  }

  @override
  Widget build(BuildContext context) {
    final alatList = _getFilteredAlatList();

    return Scaffold(
      drawer: AppDrawer(currentPage: 'Manajemen Alat'),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          SearchBarSection(
            searchController: searchController,
            onSearchChanged: () => setState(() {}),
            onTambahAlat: _showTambahAlatDialog,
          ),
          KategoriSection(
            kategoriList: kategoriList,
            selectedFilterIndex: selectedFilterIndex,
            onFilterSelected: (index) => setState(() {
              selectedFilterIndex = index;
            }),
            onTambahKategori: _showTambahKategoriDialog,
            onEditKategori: selectedFilterIndex > 0
                ? () => _showEditKategoriDialog(
                    kategoriList[selectedFilterIndex - 1],
                  )
                : null,
          ),
          Expanded(
            child: AlatSection(
              isLoading: isLoading,
              alatList: alatList,
              onEditAlat: _showEditAlatDialog,
            ),
          ),
        ],
      ),
    );
  }

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
            Text(
              'Manajemen',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Alat & Kategori',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= DIALOG HANDLERS - ALAT =================
  Future<void> _showTambahAlatDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AlatFormDialog(kategoriList: kategoriList),
    );

    if (result == null || !mounted) return;

    _showLoadingSnackBar('Menyimpan alat...');

    try {
      await _db.insertAlat(
        {
          'kategori_id': result['kategoriId'],
          'nama_alat': result['namaAlat'],
          'stok_total': result['stokTotal'],
          'kondisi': result['kondisi'],
          'is_active': true,
        },
        fotoFile:
            result['fotoFile'] ?? result['imageFile'] ?? result['imageBytes'],
      );

      _showSuccessSnackBar('Alat berhasil ditambahkan');
    } catch (e) {
      _showErrorSnackBar('Gagal: ${e.toString()}');
    }
  }

  Future<void> _showEditAlatDialog(Alat alat) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AlatFormDialog(alat: alat, kategoriList: kategoriList),
    );

    if (result == null || !mounted) return;

    _showLoadingSnackBar('Memperbarui alat...');

    try {
      await _db.updateAlat(
        alat.id,
        {
          'kategori_id': result['kategoriId'],
          'nama_alat': result['namaAlat'],
          'stok_total': result['stokTotal'],
          'stok_tersedia': result['stokTersedia'],
          'kondisi': result['kondisi'],
          'is_active': result['isActive'] ?? true,
        },
        fotoFile:
            result['fotoFile'] ?? result['imageFile'] ?? result['imageBytes'],
      );

      _showSuccessSnackBar('Alat berhasil diperbarui');
    } catch (e) {
      _showErrorSnackBar('Gagal: ${e.toString()}');
    }
  }

  // ================= DIALOG HANDLERS - KATEGORI =================
  Future<void> _showTambahKategoriDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const KategoriFormDialog(),
    );

    if (result == null || !mounted) return;

    _showLoadingSnackBar('Menyimpan kategori...');

    try {
      await _db.insertKategori({
        'nama_kategori': result['nama'],
        'is_active': result['isActive'] ?? true,
      });

      _showSuccessSnackBar('Kategori berhasil ditambahkan');
    } catch (e) {
      _showErrorSnackBar('Gagal tambah kategori: ${e.toString()}');
    }
  }

  Future<void> _showEditKategoriDialog(Kategori kategori) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => KategoriFormDialog(kategori: kategori),
    );

    if (result == null || !mounted) return;

    _showLoadingSnackBar('Memperbarui kategori...');

    try {
      await _db.updateKategori(kategori.id, {
        'nama_kategori': result['nama'],
        'is_active': result['isActive'] ?? true,
      });

      /// ⬇️ RESET FILTER JIKA KATEGORI DIMATIKAN
      if (result['isActive'] == false) {
        setState(() {
          selectedFilterIndex = 0;
        });
      }

      _showSuccessSnackBar('Kategori berhasil diperbarui');
    } catch (e) {
      _showErrorSnackBar('Gagal update kategori: ${e.toString()}');
    }
  }

  // ================= SNACKBAR HELPERS =================
  void _showLoadingSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 30),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
