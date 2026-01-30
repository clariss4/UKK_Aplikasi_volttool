import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManajemenPeminjamanScreen extends StatefulWidget {
  const ManajemenPeminjamanScreen({super.key});

  @override
  State<ManajemenPeminjamanScreen> createState() =>
      _ManajemenPeminjamanScreenState();
}

class _ManajemenPeminjamanScreenState extends State<ManajemenPeminjamanScreen> {
  static const primaryColor = Color(0xFFFB923C);
  static const bgColor = Color(0xFFF7F2EC);

  bool isPeminjaman = false; // default ke Pengembalian

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: AppDrawer(currentPage: "Manajemen Peminjaman & Pengembalian"),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearch(),
            const SizedBox(height: 14),
            _buildTabSwitcher(),
            const SizedBox(height: 16),

            // dummy card
            _buildCard(status: 'Terlambat'),
            _buildCard(status: 'Dikembalikan'),
            _buildCard(status: 'Hilang'),
            _buildCard(status: 'Rusak'),
          ],
        ),
      ),
    );
  }

  // ================= APPBAR =================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      toolbarHeight: 110,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 35, left: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manajemen',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Peminjaman & Pengembalian',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: primaryColor),
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

  // ================= SEARCH =================
  Widget _buildSearch() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari nama pengguna...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {}, // nanti filter modal
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ================= TAB =================
  Widget _buildTabSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _tabItem('Peminjaman', isPeminjaman, () {
            setState(() => isPeminjaman = true);
          }),
          _tabItem('Pengembalian', !isPeminjaman, () {
            setState(() => isPeminjaman = false);
          }),
        ],
      ),
    );
  }

  Widget _tabItem(String title, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _buildCard({required String status}) {
    Color statusColor;
    switch (status) {
      case 'Terlambat':
        statusColor = Colors.redAccent;
        break;
      case 'Dikembalikan':
        statusColor = Colors.green;
        break;
      case 'Hilang':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Clarissa Aurelia Qurnia Putri',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('Username: clarissa456@volttool.com'),
          const Text('Petugas: Sintia wiwik dwi'),
          const SizedBox(height: 6),
          const Text('Tanggal pengajuan: 10/01/2026 - 12/01/2026'),
          const Text('Dikembalikan: 12/01/2026'),
          const Text('Kondisi: Baik'),

          const SizedBox(height: 8),
          const Text('Denda:'),
          const Text(
            '• Keterlambatan: Rp. 5.000',
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
