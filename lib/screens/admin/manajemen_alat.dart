import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/alat_form_dialog.dart';
import '../../widgets/alat_card.dart';
import '../../widgets/kateogri_form_dialog.dart';
import '../../models/kategori.dart';
import '../../models/alat.dart';
import '../../services/database_service.dart';

class ManajemenAlatPage extends StatefulWidget {
  const ManajemenAlatPage({Key? key}) : super(key: key);

  @override
  State<ManajemenAlatPage> createState() => _ManajemenAlatPageState();
}

class _ManajemenAlatPageState extends State<ManajemenAlatPage> {
  int selectedFilterIndex = 0;
  final searchController = TextEditingController();
  final auth = AuthController();
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentPage: 'Manajemen Alat'),
      appBar: _buildAppBar(),
      body: StreamBuilder<List<Kategori>>(
        stream: db.streamKategori(),
        builder: (context, kategoriSnapshot) {
          if (!kategoriSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final kategoriList = kategoriSnapshot.data!;

          return StreamBuilder<List<Alat>>(
            stream: db.streamAlat(),
            builder: (context, alatSnapshot) {
              if (!alatSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Alat> alatList = alatSnapshot.data!;

              // FILTER KATEGORI
              if (selectedFilterIndex > 0) {
                final kategoriId =
                    kategoriList[selectedFilterIndex - 1].id;
                alatList = alatList
                    .where((a) => a.kategoriId == kategoriId)
                    .toList();
              }

              return Column(
                children: [
                  _buildSearchBar(kategoriList),
                  _buildFilterChips(kategoriList),
                  _buildSectionHeader(kategoriList),
                  _buildAlatList(alatList, kategoriList),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // ================= AppBar =================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFF8C42),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      toolbarHeight: 110,
      titleSpacing: 16,
      title: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Manajemen',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            Text('Alat & Kategori',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ================= Search Bar =================
  Widget _buildSearchBar(List<Kategori> kategoriList) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Cari alat atau kategori...',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlatFormDialog(kategoriList: kategoriList),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Alat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C42),
            ),
          ),
        ],
      ),
    );
  }

  // ================= Filter Chips =================
  Widget _buildFilterChips(List<Kategori> kategoriList) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kategoriList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: const Text('Tambah Kategori',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: const Color(0xFFFF8C42),
                onSelected: (_) => showDialog(
                  context: context,
                  builder: (_) => const KategoriFormDialog(),
                ),
              ),
            );
          }

          final kategori = kategoriList[index - 1];
          final isSelected = selectedFilterIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                kategori.nama,
                style: TextStyle(
                    color:
                        isSelected ? const Color(0xFFFF8C42) : Colors.white),
              ),
              selected: isSelected,
              showCheckmark: false,
              backgroundColor: const Color(0xFFFF8C42),
              selectedColor: Colors.white,
              onSelected: (_) =>
                  setState(() => selectedFilterIndex = index),
            ),
          );
        },
      ),
    );
  }

  // ================= Section Header =================
  Widget _buildSectionHeader(List<Kategori> kategoriList) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        selectedFilterIndex > 0
            ? kategoriList[selectedFilterIndex - 1].nama
            : 'Semua Alat',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ================= List Alat =================
  Widget _buildAlatList(
      List<Alat> alatList, List<Kategori> kategoriList) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: alatList.length,
        itemBuilder: (context, index) {
          return AlatCard(
            alat: alatList[index],
            onEdit: () => showDialog(
              context: context,
              builder: (_) => AlatFormDialog(
                alat: alatList[index],
                kategoriList: kategoriList,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
