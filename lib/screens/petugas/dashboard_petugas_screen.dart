import 'package:apk_peminjaman/Widgets/Petugas/dashboard/request_card.dart';
import 'package:apk_peminjaman/Widgets/Petugas/dashboard/section_tiltte.dart';
import 'package:apk_peminjaman/Widgets/Petugas/dashboard/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/main_drawer.dart';


class DashboardPetugasScreen extends StatelessWidget {
  const DashboardPetugasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      drawer: AppDrawer(currentPage: 'Dashboard Petugas'),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFB923C),
        elevation: 0,
        toolbarHeight: 110,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Text(
            'Dashboard',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STAT CARDS
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    value: '15',
                    label: 'Sedang dipinjam',
                    icon: Icons.access_time,
                    backgroundColor: Color(0xFFFFC78E),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    value: '9',
                    label: 'Dikembalikan',
                    icon: Icons.assignment_turned_in,
                    backgroundColor: Color(0xFFFFF1E6),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const SectionTitle(title: 'Permintaan Terbaru'),

            const SizedBox(height: 12),

            const RequestCard(),
            const RequestCard(),
            const RequestCard(),
            const RequestCard(),
          ],
        ),
      ),
    );
  }
}
