import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:apk_peminjaman/Widgets/peminjaman_list.dart';
import 'package:apk_peminjaman/controllers/auth_controller.dart';
import 'package:apk_peminjaman/models/data_dashboard.dart';
import 'package:apk_peminjaman/widgets/activity_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final auth = AuthController();
  int selectedFilter = 0; // 0 = Aktivitas, 1 = Peminjaman

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5efeb),
      appBar: _buildAppBar(),
      drawer: AppDrawer(currentPage: 'Dashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCards(),
            const SizedBox(height: 20),
            buildFilterTabs(),
            const SizedBox(height: 16),
            selectedFilter == 0
                ? ActivityList(logs: DASHBOARD_LOGS)
                : PeminjamanList(items: PEMINJAMAN_HARI_INI),
          ],
        ),
      ),
    );
  }

  // ================= APPBAR =================
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFB923C),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      toolbarHeight: 110,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 35, left: 4),
        child: Text(
          'Dashboard',
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFFFB923C)),
              ),
              SizedBox(height: 4),
              Text(
                'admin',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= STAT CARDS =================
  Widget _buildStatCards() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "67",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfffb923c),
                    ),
                  ),
                  Text(
                    "Total Unit Alat Tersedia",
                    style: TextStyle(color: Color(0xfffcca95)),
                  ),
                ],
              ),
              Icon(Icons.inventory, size: 40, color: Colors.orange),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _smallCard(
                title: "15",
                subtitle: "Sedang Dipinjam",
                icon: Icons.access_time,
                backgroundColor: Colors.orange.shade200,
                contentColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _smallCard(
                title: "9",
                subtitle: "Dikembalikan",
                icon: Icons.assignment_turned_in,
                backgroundColor: const Color(0xfffff5ed),
                contentColor: const Color(0xfffb923c),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _smallCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    Color? contentColor,
  }) {
    final color = contentColor ?? Colors.black;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: color)),
          const SizedBox(height: 8),
          Icon(icon, color: color),
        ],
      ),
    );
  }

  // ================= FILTER TABS =================
  Widget _tabItem({required int index, required String text}) {
    final bool isActive = selectedFilter == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedFilter = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFFB923C) // active (orange)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white70.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          _tabItem(index: 0, text: "Aktivitas Hari Ini"),
          _tabItem(index: 1, text: "Sedang Dipinjam"),
        ],
      ),
    );
  }
}
