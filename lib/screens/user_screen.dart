import 'package:apk_peminjaman/widgets/user_edit_bottom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/main_drawer.dart';
import '../data_dummy.dart';
import '../models/user.dart';
import '../widgets/user_card.dart';
import '../screens/user_form_page.dart';
import '../Widgets/user_edit_bottom.dart' hide UserEditBottomSheet;

/// Halaman utama Manajemen Pengguna
class ManajemenPenggunaPage extends StatefulWidget {
  const ManajemenPenggunaPage({Key? key}) : super(key: key);

  @override
  State<ManajemenPenggunaPage> createState() => _ManajemenPenggunaPageState();
}

class _ManajemenPenggunaPageState extends State<ManajemenPenggunaPage> {
  int selectedFilterIndex = 1; // 0 = Petugas, 1 = Peminjam
  final searchController = TextEditingController();

  /// Get filtered users berdasarkan role dan search query
  List<User> get filteredUsers {
    List<User> list;

    // Filter berdasarkan role
    if (selectedFilterIndex == 0) {
      list = DummyData.userList.where((u) => u.role == 'petugas').toList();
    } else {
      list = DummyData.userList.where((u) => u.role == 'peminjam').toList();
    }

    // Filter berdasarkan search query
    if (searchController.text.isNotEmpty) {
      list = list
          .where(
            (u) =>
                u.namaLengkap.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ||
                u.username.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
          )
          .toList();
    }

    return list;
  }

  /// Tampilkan snackbar sukses (hijau)
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

  /// Tampilkan snackbar error (merah)
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.close, color: Colors.white),
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

  /// Tampilkan bottom sheet untuk edit user
  void _showEditBottomSheet(User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: UserEditBottomSheet(user: user),
      ),
    ).then((result) {
      // Jika ada result (data user yang diupdate)
      if (result != null) {
        _showSuccessSnackbar('Berhasil memperbarui pengguna baru');
        // TODO: Update data di database atau state management
      }
    });
  }

  /// Tampilkan halaman tambah user
  void _showAddUserPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserFormPage()),
    ).then((result) {
      // Jika ada result (data user yang ditambahkan)
      if (result != null) {
        // Untuk demo, tampilkan error sesuai requirement
        _showErrorSnackbar('Gagal menambahkan pengguna baru');
        // TODO: Tambah data ke database atau state management
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentPage: 'Manajemen Pengguna'),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndAddButton(),
          _buildFilterTabs(),
          _buildUserList(),
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
                'Admin',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build Search Bar dan Tombol + User
  Widget _buildSearchAndAddButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari nama pengguna...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: Icon(Icons.search, color: Colors.grey[600]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _showAddUserPage,
            icon: const Icon(Icons.add, size: 20),
            label: const Text('User'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB923C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Filter Tabs (Petugas/Peminjam)
  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white70.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          _tabItem(index: 0, text: 'Petugas'),
          _tabItem(index: 1, text: 'Peminjam'),
        ],
      ),
    );
  }

  /// Build single tab item
  Widget _tabItem({required int index, required String text}) {
    final bool isActive = selectedFilterIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilterIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFB923C) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xff2b2b2b),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build User List
  Widget _buildUserList() {
    final list = filteredUsers;

    return Expanded(
      child: list.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada pengguna',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return UserCard(
                  user: list[index],
                  onEdit: () => _showEditBottomSheet(list[index]),
                );
              },
            ),
    );
  }
}
