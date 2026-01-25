import 'package:apk_peminjaman/screens/borrow_tool_page.dart';
import 'package:apk_peminjaman/screens/daftar_alat%20pinjam.dart';
import 'package:apk_peminjaman/screens/dashboard_petugas_screen.dart';
import 'package:apk_peminjaman/screens/konfirmasi_peminjaam_screen.dart';
import 'package:apk_peminjaman/screens/log_aktivitas_screen.dart';
import 'package:apk_peminjaman/screens/manajemen_peminjaman.dart';
import 'package:apk_peminjaman/screens/report_page.dart';
import 'package:apk_peminjaman/screens/return_request_page.dart';
import 'package:apk_peminjaman/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:apk_peminjaman/controllers/auth_controller.dart';
import 'package:apk_peminjaman/screens/dashboard_admin_screen.dart';
import 'package:apk_peminjaman/screens/login_screen.dart';
import 'package:apk_peminjaman/screens/manajemen_alat.dart';

class AppDrawer extends StatelessWidget {
  final AuthController auth = AuthController();
  final String currentPage; // nama halaman saat ini untuk highlight

  AppDrawer({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFFB923C)),
            child: Text(
              'Menu Admin',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dashboard,
            label: 'Dashboard',
            pageName: 'Dashboard',
            targetPage: const DashboardScreen(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.inventory,
            label: 'Manajemen Alat',
            pageName: 'Manajemen Alat',
            targetPage: const ManajemenAlatPage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people,
            label: 'Manajemen Pengguna',
            pageName: 'Manajemen Pengguna',
            targetPage: const ManajemenPenggunaPage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.history,
            label: 'Log Aktivitas',
            pageName: 'Log Aktivitas',
            targetPage: const LogAktivitasPage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.playlist_add_check_sharp,
            label: 'Manajemen Peminjaman & Pengembalian',
            pageName: 'Manajemen Peminjaman & Pengembalian',
            targetPage: const ManajemenPeminjamanScreen(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dashboard,
            label: 'Dashboard Petugas',
            pageName: 'Dashboard Petugas',
            targetPage: DashboardPetugasScreen(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.inventory,
            label: 'Konfirmasi peminjaman',
            pageName: 'Konfirmasi peminjaman',
            targetPage: BorrowingPage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.inventory,
            label: 'Konfirmasi pengembalian',
            pageName: 'Konfirmasi pengembalian',
            targetPage: ReturnRequestPage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.inventory,
            label: 'Laporan',
            pageName: 'Laporan',
            targetPage: ReportPage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.inventory,
            label: 'Peminjaman Alat',
            pageName: 'Peminjaman Alat',
            targetPage: BorrowToolsPage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.inventory,
            label: 'Daftar Alat',
            pageName: 'Daftar Alat',
            targetPage: DaftarAlatPage(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await auth.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String pageName,
    required Widget targetPage,
  }) {
    final isSelected = currentPage == pageName;

    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFFFB923C) : null),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFFFB923C) : null,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (!isSelected) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => targetPage),
          );
        }
      },
    );
  }
}
