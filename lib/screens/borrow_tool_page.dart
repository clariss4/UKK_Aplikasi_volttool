import 'package:flutter/material.dart';
import 'package:apk_peminjaman/Widgets/main_drawer.dart';

class BorrowToolsPage extends StatefulWidget {
  const BorrowToolsPage({super.key});

  @override
  State<BorrowToolsPage> createState() => _BorrowToolsPageState();
}

class _BorrowToolsPageState extends State<BorrowToolsPage> {
  String selectedCategory = 'Alat Ukur';

  final List<Map<String, dynamic>> tools = List.generate(4, (_) {
    return {
      'name': 'Tang tangan',
      'total': 34,
      'available': 24,
      'condition': 'Baik',
      'qty': 0,
    };
  });

  int get totalInBag =>
      tools.fold(0, (sum, item) => sum + (item['qty'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentPage: 'Peminjaman Alat'),
      backgroundColor: const Color(0xFFF7F2EC),

      // ================= HEADER =================
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 12),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFFFB923C)),
                  ),
                  SizedBox(height: 4),
                  Text('Peminjam',
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
            )
          ],
        ),
      ),

      // ================= BODY =================
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SEARCH
                _searchBar(),
                const SizedBox(height: 12),

                // CATEGORY
                _categorySelector(),
                const SizedBox(height: 20),

                const Text(
                  'Alat Ukur',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),

                // LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: tools.length,
                    itemBuilder: (context, index) {
                      return _toolCard(index);
                    },
                  ),
                ),
              ],
            ),
          ),

          // ================= FLOATING BAG =================
          if (totalInBag > 0)
            Positioned(
              bottom: 24,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  _showBag(context);
                },
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

  // ================= COMPONENTS =================

  Widget _searchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: const [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari alat atau kategori...',
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.search, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _categorySelector() {
    return Row(
      children: [
        _categoryChip('Alat Ukur'),
        const SizedBox(width: 8),
        _categoryChip('Alat Solder'),
        const SizedBox(width: 8),
        _categoryChip('Alat Kerja listrik'),
      ],
    );
  }

  Widget _categoryChip(String title) {
    final bool active = selectedCategory == title;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFDBA74) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFDBA74)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : const Color(0xFFFB923C),
          ),
        ),
      ),
    );
  }

  Widget _toolCard(int index) {
    final tool = tools[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // IMAGE
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.build, size: 36),
          ),
          const SizedBox(width: 12),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tool['name'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text('Stok total: ${tool['total']}'),
                Text('Stok Tersedia: ${tool['available']}'),
                Text('Kondisi: ${tool['condition']}'),
                const SizedBox(height: 8),

                // QTY
                Row(
                  children: [
                    const Text('Jumlah:'),
                    const SizedBox(width: 8),
                    _qtyButton(Icons.remove, () {
                      if (tool['qty'] > 0) {
                        setState(() => tool['qty']--);
                      }
                    }),
                    Container(
                      width: 32,
                      alignment: Alignment.center,
                      child: Text('${tool['qty']}'),
                    ),
                    _qtyButton(Icons.add, () {
                      if (tool['qty'] < tool['available']) {
                        setState(() => tool['qty']++);
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),

          // PINJAM
          ElevatedButton(
            onPressed: tool['qty'] > 0 ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB7C12),
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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

  // ================= BAG POPUP =================

  void _showBag(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final bagItems =
            tools.where((item) => item['qty'] > 0).toList();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bag Peminjaman',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              ...bagItems.map((item) {
                return ListTile(
                  title: Text(item['name']),
                  trailing: Text('${item['qty']}x'),
                );
              }),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // NEXT: kirim ke backend
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFB7C12),
                  ),
                  child: const Text('Ajukan Peminjaman'),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
