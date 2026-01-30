import 'package:flutter/material.dart';
import 'package:apk_peminjaman/Widgets/main_drawer.dart';

class BorrowingPage extends StatelessWidget {
  const BorrowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentPage: 'Permintaan Peminjaman'),
      backgroundColor: const Color(0xFFF6F1EB),

      // ===== HEADER ORANYE =====
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: const Color(0xFFFB923C),
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 8, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Permintaan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  'peminjaman',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 4),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFFFB923C)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Petugas',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== SEARCH BAR =====
            Container(
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
                        hintText: 'Cari permintaan pinjaman...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== LIST =====
            Expanded(
              child: ListView(
                children: const [
                  BorrowingCard(),
                  BorrowingCard(),
                  BorrowingCard(),
                  BorrowingCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// ========================= CARD ITEM ================================
// ===================================================================

class BorrowingCard extends StatelessWidget {
  const BorrowingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER CARD =====
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Clarissa Aurelia QP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Meminjam',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFFB923C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '09:30',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Tang tangan 1x\nTang pengupas kabel 1x',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),

          const SizedBox(height: 12),

          const Text(
            'Batas pengembalian',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          const Text(
            '02/02/2026',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),

          const SizedBox(height: 12),

          // ===== STATUS =====
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F76D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Status: Menunggu',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 12),

          // ===== BUTTONS =====
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Konfirmasi',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDBA74),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Lihat', style: TextStyle(fontSize: 13)),
                      SizedBox(width: 6),
                      Icon(Icons.remove_red_eye, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
