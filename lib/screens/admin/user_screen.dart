import 'package:apk_peminjaman/Widgets/User/dialogs/active_confirmation_dialog.dart';
import 'package:apk_peminjaman/Widgets/User/dialogs/delete_confirmation_dialog.dart';
import 'package:apk_peminjaman/Widgets/User/user_filter_tab.dart';
import 'package:apk_peminjaman/Widgets/User/user_formdialog.dart';
import 'package:apk_peminjaman/Widgets/User/user_list_view.dart';
import 'package:apk_peminjaman/Widgets/User/user_search_bar.dart';
import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:apk_peminjaman/controllers/user_controller.dart';
import 'package:apk_peminjaman/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManajemenPenggunaPage extends StatefulWidget {
  const ManajemenPenggunaPage({Key? key}) : super(key: key);

  @override
  State<ManajemenPenggunaPage> createState() => _ManajemenPenggunaPageState();
}

class _ManajemenPenggunaPageState extends State<ManajemenPenggunaPage> {
  final UserController _userController = UserController();
  final TextEditingController searchController = TextEditingController();
  int selectedFilterIndex = 0; // 0 = Admin, 1 = Petugas, 2 = Peminjam
  bool _isLoadingAdd = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Tampilkan dialog tambah user
  void _showAddUserDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          UserFormDialog(mode: UserFormMode.add, controller: _userController),
    );

    // ✅ Jika berhasil tambah user
    if (result == true) {
      setState(() => _isLoadingAdd = true);

      // ✅ DELAY untuk kasih waktu realtime update
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        setState(() => _isLoadingAdd = false);
      }
    }
  }

  /// Tampilkan dialog edit user
  void _showEditUserDialog(User user) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // tidak bisa close saat loading
      builder: (_) => UserFormDialog(
        mode: UserFormMode.edit,
        user: user,
        controller: _userController, // tambahkan controller
      ),
    );
  }

  /// Konfirmasi soft delete atau aktivasi user
  Future<void> _confirmDeleteUser(User user) async {
    // ✅ Jika user sudah non-aktif, tawarkan untuk mengaktifkan kembali
    if (!user.isActive) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => ActivateConfirmationDialog(user: user),
      );

      if (confirm == true) {
        try {
          await _userController.activateUser(user.id);
          if (mounted) {
            _showSuccessSnackbar('Pengguna berhasil diaktifkan kembali');
          }
        } catch (e) {
          if (mounted) {
            _showErrorSnackbar('Gagal mengaktifkan pengguna: ${e.toString()}');
          }
        }
      }
      return;
    }

    // Jika user masih aktif, lakukan soft delete
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(user: user),
    );

    if (confirm == true) {
      try {
        await _userController.deleteUser(user.id);
        if (mounted) {
          _showSuccessSnackbar('Pengguna berhasil dinonaktifkan');
        }
      } catch (e) {
        if (mounted) {
          _showErrorSnackbar('Gagal menonaktifkan pengguna: ${e.toString()}');
        }
      }
    }
  }

  /// Snackbar sukses
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Snackbar error
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Get role berdasarkan selected index
  String _getSelectedRole() {
    switch (selectedFilterIndex) {
      case 0:
        return 'admin';
      case 1:
        return 'petugas';
      case 2:
        return 'peminjam';
      default:
        return 'peminjam';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentPage: 'Manajemen Pengguna'),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search bar
          UserSearchBar(
            controller: searchController,
            onChanged: () => setState(() {}),
            onAddPressed: _showAddUserDialog,
          ),

          // Filter tabs
          UserFilterTabs(
            selectedIndex: selectedFilterIndex,
            onTabChanged: (index) =>
                setState(() => selectedFilterIndex = index),
          ),

          // ✅ User list - REALTIME
          Expanded(
            child: UserListView(
              controller: _userController,
              searchQuery: searchController.text,
              selectedRole: _getSelectedRole(),
              onEdit: _showEditUserDialog,
              onDelete: _confirmDeleteUser,
            ),
          ),
          // ✅ LOADING OVERLAY SAAT TAMBAH USER
          if (_isLoadingAdd)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFB923C),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Menambahkan pengguna...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFB923C),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      toolbarHeight: 120,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 35, left: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manajemen',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Pengguna',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
