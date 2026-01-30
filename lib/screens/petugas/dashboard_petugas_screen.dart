import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPetugasScreen extends StatelessWidget {
  const DashboardPetugasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      drawer: AppDrawer(currentPage: 'Dashboard Petugas'),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFB923C),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        toolbarHeight: 110,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 35, left: 4),
          child: Text(
            'Dashboard',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFFFB923C)),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= STAT CARDS =================
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    value: '15',
                    label: 'Sedang dipinjam',
                    icon: Icons.access_time,
                    color: const Color(0xFFFFC78E),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    value: '9',
                    label: 'Dikembalikan',
                    icon: Icons.assignment_turned_in,
                    color: const Color(0xFFFFF1E6),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ================= TITLE =================
            const Text(
              'Permintaan Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            // ================= REQUEST LIST =================
            _requestCard(),
            _requestCard(),
            _requestCard(),
            _requestCard(),
          ],
        ),
      ),
    );
  }

  // ================= STAT CARD =================
  Widget _statCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  // ================= REQUEST CARD =================
  Widget _requestCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Clarissa Aurelia QP',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('09:30', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),

          const SizedBox(height: 4),

          const Text(
            'Meminjam',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Tang tangan 1x\nTang pengupas kabel 1x',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 8),

          const Text(
            'Batas pengembalian',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),

          const Text(
            '02/02/2026',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 10),

          // STATUS BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE9FF9A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Status: Menunggu',
              style: TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
