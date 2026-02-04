import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:apk_peminjaman/controllers/borrow_cart_controller.dart';
import 'package:apk_peminjaman/models/alat.dart';
import 'package:apk_peminjaman/models/kategori.dart';
import 'package:apk_peminjaman/screens/peminjam/borrow_cart_page.dart';
import 'package:apk_peminjaman/services/database_service.dart';

class BorrowToolsPage extends StatefulWidget {
  const BorrowToolsPage({super.key});

  @override
  State<BorrowToolsPage> createState() => _BorrowToolsPageState();
}

class _BorrowToolsPageState extends State<BorrowToolsPage> {
  final DatabaseService _db = DatabaseService();

  List<Alat> tools = [];
  List<Kategori> categories = [];

  String? selectedKategoriId;
  String searchKeyword = '';
  bool isLoading = true;

  bool get isSearching => searchKeyword.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final alatList = await _db.getAlatUntukPeminjam();
    final kategoriList = await _db.getKategoriUntukPeminjam();

    /// ✅ hanya kategori yang punya alat aktif & stok > 0
    final filteredKategori = kategoriList.where((k) {
      return alatList.any(
        (a) => a.kategoriId == k.id && a.stokTersedia > 0,
      );
    }).toList();

    setState(() {
      tools = alatList;
      categories = filteredKategori;
      selectedKategoriId =
          filteredKategori.isNotEmpty ? filteredKategori.first.id : null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<BorrowCartController>();
    final totalInBag = cart.totalQty;

    return Scaffold(
      drawer: AppDrawer(currentPage: 'Peminjaman Alat'),
      backgroundColor: const Color(0xFFF7F2EC),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFFB923C),
          title: const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'Peminjaman Alat',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchBar(),
                const SizedBox(height: 12),

                _categorySelector(),
                const SizedBox(height: 20),

                if (!isSearching && selectedKategoriId != null)
                  Text(
                    categories
                        .firstWhere((k) => k.id == selectedKategoriId)
                        .namaKategori,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),

                const SizedBox(height: 12),

                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          children: tools.where((t) {
                            final matchSearch = t.namaAlat
                                .toLowerCase()
                                .contains(searchKeyword);

                            if (isSearching) {
                              return matchSearch;
                            }

                            return t.kategoriId == selectedKategoriId &&
                                matchSearch;
                          }).map((t) => _toolCard(t, cart)).toList(),
                        ),
                ),
              ],
            ),
          ),

          if (totalInBag > 0)
            Positioned(
              bottom: 24,
              right: 16,
              child: GestureDetector(
                onTap: () => _showBag(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_bag,
                          color: Color(0xFFFB923C)),
                      const SizedBox(width: 8),
                      Text(
                        'Bag ($totalInBag)',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// ================= SEARCH BAR =================
  Widget _searchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() => searchKeyword = value.toLowerCase());
              },
              decoration: const InputDecoration(
                hintText: 'Cari alat...',
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.search, color: Colors.grey),
        ],
      ),
    );
  }

  /// ================= KATEGORI =================
  Widget _categorySelector() {
    final visibleCategories = isSearching
        ? categories.where((k) {
            return tools.any((a) =>
                a.kategoriId == k.id &&
                a.namaAlat.toLowerCase().contains(searchKeyword));
          }).toList()
        : categories;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: visibleCategories.map((c) {
          final active = selectedKategoriId == c.id;
          return GestureDetector(
            onTap: () => setState(() => selectedKategoriId = c.id),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFFDBA74) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDBA74)),
              ),
              child: Text(
                c.namaKategori,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      active ? Colors.white : const Color(0xFFFB923C),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// ================= TOOL CARD =================
  Widget _toolCard(Alat t, BorrowCartController cart) {
    final qty = cart.getQty(t.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: t.fotoUrl == null
                ? const Icon(Icons.build, size: 36)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      t.fotoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.namaAlat,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text('Stok tersedia: ${t.stokTersedia}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Jumlah:'),
                    const SizedBox(width: 8),
                    _qtyButton(Icons.remove,
                        () => cart.decrease(t.id)),
                    Container(
                      width: 32,
                      alignment: Alignment.center,
                      child: Text('$qty'),
                    ),
                    _qtyButton(
                      Icons.add,
                      () => cart.addManual(
                        id: t.id,
                        nama: t.namaAlat,
                        stok: t.stokTersedia,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: () => cart.addManual(
              id: t.id,
              nama: t.namaAlat,
              stok: t.stokTersedia,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB7C12),
            ),
            child: const Text('Pinjam'),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  /// ================= BAG =================
  void _showBag(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BorrowCartPage(),
      ),
    );
  }
}
