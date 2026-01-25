import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:apk_peminjaman/data_dummy.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../widgets/alat_form_dialog.dart';
import '../widgets/alat_card.dart';
import '../widgets/kateogri_form_dialog.dart';
import '../models/kategori.dart';
import '../models/alat.dart';

class ManajemenAlatPage extends StatefulWidget {
  const ManajemenAlatPage({Key? key}) : super(key: key);

  @override
  State<ManajemenAlatPage> createState() => _ManajemenAlatPageState();
}

class _ManajemenAlatPageState extends State<ManajemenAlatPage> {
  int selectedFilterIndex = 0;
  final searchController = TextEditingController();
  final auth = AuthController();

  // ambil dari dummy
  List<Kategori> get kategoriList => DummyData.kategoriList;
  List<Alat> get alatList => DummyData.alatList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentPage: 'Manajemen Alat'),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          _buildSectionHeader(),
          _buildAlatList(),
        ],
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
            Text(
              'Manajemen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Alat & Kategori',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16, top: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFFFF8C42)),
              ),
              SizedBox(height: 4),
              Text(
                'Admin',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= Drawer =================
  // ================= Search Bar =================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari alat atau kategori...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlatFormDialog(kategoriList: kategoriList),
            ),
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Alat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C42),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= Filter Chips =================
  Widget _buildFilterChips() {
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
                label: Row(
                  children: const [
                    Icon(Icons.add, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Tambah Kategori',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFFFF8C42),
                side: const BorderSide(color: Color(0xFFFF8C42)),
                onSelected: (_) => showDialog(
                  context: context,
                  builder: (context) => const KategoriFormDialog(),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            );
          }

          final kategori = kategoriList[index - 1];
          final isSelected = selectedFilterIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onLongPress: () => showDialog(
                context: context,
                builder: (context) => KategoriFormDialog(kategori: kategori),
              ),
              child: FilterChip(
                label: Text(
                  kategori.nama,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFFFF8C42),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                backgroundColor: Colors.white,
                selectedColor: Colors.orange[300],
                side: const BorderSide(color: Color(0xFFFF8C42)),
                onSelected: (_) => setState(() => selectedFilterIndex = index),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= Section Header =================
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedFilterIndex > 0
                ? kategoriList[selectedFilterIndex - 1].nama
                : 'Semua Alat',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (selectedFilterIndex > 0)
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFFFF8C42)),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => KategoriFormDialog(
                  kategori: kategoriList[selectedFilterIndex - 1],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ================= List Alat =================
  Widget _buildAlatList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: alatList.length,
        itemBuilder: (context, index) {
          return AlatCard(
            alat: alatList[index],
            onEdit: () => showDialog(
              context: context,
              builder: (context) => AlatFormDialog(
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
