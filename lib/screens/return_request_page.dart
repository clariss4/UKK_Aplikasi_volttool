import 'package:flutter/material.dart';
import 'package:apk_peminjaman/Widgets/main_drawer.dart';

class ReturnRequestPage extends StatelessWidget {
  const ReturnRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentPage: 'Permintaan pengembalian'),
      backgroundColor: const Color(0xFFF7F2EC),

      // ================= HEADER =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: AppBar(
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
                  'Pengembalian',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
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
                  Text(
                    'Petugas',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SEARCH
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

            Expanded(
              child: ListView(
                children: const [
                  ReturnCard(status: ReturnStatus.menunggu, showConfirm: true),
                  ReturnCard(status: ReturnStatus.selesai, showConfirm: false),
                  ReturnCard(status: ReturnStatus.terlambat, showConfirm: true),
                  ReturnCard(status: ReturnStatus.hilang, showConfirm: true),
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
// ========================== CARD ===================================
// ===================================================================

enum ReturnStatus { menunggu, selesai, terlambat, hilang }

class ReturnCard extends StatelessWidget {
  final ReturnStatus status;
  final bool showConfirm;

  const ReturnCard({
    super.key,
    required this.status,
    required this.showConfirm,
  });

  Color get statusColor {
    switch (status) {
      case ReturnStatus.menunggu:
        return const Color(0xFFE7F76D);
      case ReturnStatus.selesai:
        return const Color(0xFF86EFAC);
      case ReturnStatus.terlambat:
        return const Color(0xFFFCA5A5);
      case ReturnStatus.hilang:
        return const Color(0xFFDC2626);
    }
  }

  Color get statusTextColor =>
      status == ReturnStatus.hilang ? Colors.white : Colors.black;

  String get statusText {
    switch (status) {
      case ReturnStatus.menunggu:
        return 'Menunggu';
      case ReturnStatus.selesai:
        return 'Selesai';
      case ReturnStatus.terlambat:
        return 'Terlambat';
      case ReturnStatus.hilang:
        return 'Hilang';
    }
  }

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
          // HEADER
          Row(
            children: const [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clarissa Aurelia QP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Dikembalikan',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFFB923C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text('09:30', style: TextStyle(fontSize: 12, color: Colors.grey)),
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

          // STATUS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Status: $statusText',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusTextColor,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // BUTTON
          Row(
            children: [
              if (showConfirm)
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
              if (showConfirm) const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const ReturnDetailDialog(),
                    );
                  },
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

// ===================================================================
// ======================= POPUP DETAIL ===============================
// ===================================================================

class ReturnDetailDialog extends StatelessWidget {
  const ReturnDetailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFFB923C),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Clarissa Aurelia QP',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),

            const SizedBox(height: 12),
            const Text(
              'Alat yang dikembalikan',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            _toolItem('Tang tangan', '1x'),
            const SizedBox(height: 8),
            _toolItem('Tang pengupas kabel', '1x'),

            const SizedBox(height: 16),
            const Text(
              'Tanggal pengembalian',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text('02/02/2026'),
          ],
        ),
      ),
    );
  }

  static Widget _toolItem(String name, String qty) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.build, color: Color(0xFFFB923C)),
          const SizedBox(width: 12),
          Expanded(child: Text(name)),
          Text(qty, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
