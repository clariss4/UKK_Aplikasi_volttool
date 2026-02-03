import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apk_peminjaman/screens/peminjam/borrow_tool_page.dart';
import 'package:apk_peminjaman/screens/peminjam/daftar_alat%20pinjam.dart';
import 'package:apk_peminjaman/screens/peminjam/dashboard_page.dart';
import 'package:apk_peminjaman/screens/petugas/dashboard_petugas_screen.dart';
import 'package:apk_peminjaman/screens/petugas/konfirmasi_peminjaam_screen.dart';
import 'package:apk_peminjaman/screens/petugas/return_request_page.dart';
import 'package:apk_peminjaman/screens/petugas/report_page.dart';
import 'package:apk_peminjaman/screens/admin/dashboard_admin_screen.dart';
import 'package:apk_peminjaman/screens/admin/log_aktivitas_screen.dart';
import 'package:apk_peminjaman/screens/admin/manajemen_alat.dart';
import 'package:apk_peminjaman/screens/admin/manajemen_peminjaman.dart';
import 'package:apk_peminjaman/screens/admin/user_screen.dart';
import 'package:apk_peminjaman/screens/login_screen.dart';
import 'package:apk_peminjaman/controllers/auth_controller.dart';

class AppDrawer extends StatefulWidget {
  final String currentPage;

  const AppDrawer({Key? key, required this.currentPage}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthController auth = AuthController();
  String? role;
  String? name;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final r = await auth.getRole();
    final n = await auth.getName();
    final prefs = await SharedPreferences.getInstance();
    final u = prefs.getString('username'); // ambil username dari session
    setState(() {
      role = r;
      name = n ?? 'User';
      username = u ?? 'username';
    });
  }

  Color _avatarColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'petugas':
        return Colors.orange;
      case 'peminjam':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Logout',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    'Konfirmasi Logout',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// CONTENT
                  Text(
                    'Apakah Anda yakin ingin keluar dari akun ini?',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ACTIONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[800],
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFB923C),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },

      /// ANIMASI POP (INI YANG BIKIN GA JELEK)
      transitionBuilder: (ctx, anim, _, child) {
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.92,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(anim),
            child: child,
          ),
        );
      },
    );

    if (shouldLogout == true) {
      await auth.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return const Drawer(child: Center(child: CircularProgressIndicator()));
    }

    final initials = name!.isNotEmpty
        ? name!.trim().split(' ').map((e) => e[0]).take(2).join()
        : 'U';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ================== MODERN HEADER ==================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            color: const Color(0xFFFB923C),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: _avatarColor(role!),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        username!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // =================== ADMIN MENU ===================
          if (role == 'admin') ...[
            _buildDrawerItem(
              context,
              icon: Icons.dashboard,
              label: 'Dashboard Admin',
              pageName: 'Dashboard Admin',
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
              icon: Icons.playlist_add_check_sharp,
              label: 'Manajemen Peminjaman & Pengembalian',
              pageName: 'Manajemen Peminjaman & Pengembalian',
              targetPage: const ManajemenPeminjamanScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.history,
              label: 'Log Aktivitas',
              pageName: 'Log Aktivitas',
              targetPage: const LogAktivitasPage(),
            ),
          ],

          // =================== PETUGAS MENU ===================
          if (role == 'petugas') ...[
            _buildDrawerItem(
              context,
              icon: Icons.dashboard,
              label: 'Dashboard Petugas',
              pageName: 'Dashboard Petugas',
              targetPage: const DashboardPetugasScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.playlist_add_check,
              label: 'Konfirmasi Peminjaman',
              pageName: 'Konfirmasi Peminjaman',
              targetPage: const BorrowingPage(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.playlist_add_check,
              label: 'Konfirmasi Pengembalian',
              pageName: 'Konfirmasi Pengembalian',
              targetPage: const ReturnRequestPage(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.price_check,
              label: 'Laporan',
              pageName: 'Laporan',
              targetPage: const ReportPage(),
            ),
          ],

          // =================== PEMINJAM MENU ===================
          if (role == 'peminjam') ...[
            _buildDrawerItem(
              context,
              icon: Icons.dashboard,
              label: 'Dashboard Peminjam',
              pageName: 'Dashboard Peminjam',
              targetPage: const DashboardPage(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.inventory,
              label: 'Peminjaman Alat',
              pageName: 'Peminjaman Alat',
              targetPage: const BorrowToolsPage(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.inventory,
              label: 'Daftar Alat',
              pageName: 'Daftar Alat',
              targetPage: const DaftarAlatPage(),
            ),
          ],

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.orange),
            title: const Text('Logout', style: TextStyle(color: Colors.orange)),
            onTap: _confirmLogout,
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
    final isSelected = widget.currentPage == pageName;

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
