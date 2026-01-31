import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Widgets/main_drawer.dart';
import '../../Widgets/User/user_formdialog.dart';
import '../../widgets/user_card.dart';
import '../../models/user.dart';
import '../../controllers/user_controller.dart';

class ManajemenPenggunaPage extends StatefulWidget {
  const ManajemenPenggunaPage({Key? key}) : super(key: key);

  @override
  State<ManajemenPenggunaPage> createState() => _ManajemenPenggunaPageState();
}

class _ManajemenPenggunaPageState extends State<ManajemenPenggunaPage> {
  final UserController _userController = UserController();
  final TextEditingController searchController = TextEditingController();
  int selectedFilterIndex = 1; // 0 = Petugas, 1 = Peminjam

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showAddUserDialog() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const UserFormDialog(mode: UserFormMode.add),
    );

    if (result != null && result is Map<String, dynamic>) {
      await _userController.insertUser(result); // tersimpan di Supabase
      _showSuccessSnackbar('Berhasil menambahkan pengguna baru');
    }
  }

  void _showEditUserDialog(User user) async {
    final result = await showDialog(
      context: context,
      builder: (_) => UserFormDialog(mode: UserFormMode.edit, user: user),
    );

    if (result != null && result is Map<String, dynamic>) {
      await _userController.updateUser(user.id, result);
      _showSuccessSnackbar('Berhasil memperbarui pengguna');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentPage: 'Manajemen Pengguna'),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndAddButton(),
          _buildFilterTabs(),
          _buildUserList(), // pakai StreamBuilder
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return Expanded(
      child: StreamBuilder<List<User>>(
        stream: _userController.streamUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snapshot.data ?? [];

          // Filter role & search
          final filtered = list.where((u) {
            if (!u.isActive) return false;
            if (selectedFilterIndex == 0) return u.role == 'petugas';
            return u.role == 'peminjam';
          }).where((u) {
            final query = searchController.text.toLowerCase();
            return u.namaLengkap.toLowerCase().contains(query) ||
                u.username.toLowerCase().contains(query);
          }).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Tidak ada pengguna',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return UserCard(
                user: filtered[index],
                onEdit: () => _showEditUserDialog(filtered[index]),
              );
            },
          );
        },
      ),
    );
  }

  // AppBar, search, filter tabs tetap seperti semula
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
            Text('Manajemen',
                style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            Text('Pengguna',
                style: GoogleFonts.inter(
                    fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
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
                  child: Icon(Icons.person, color: Color(0xFFFB923C))),
              SizedBox(height: 4),
              Text('Admin', style: TextStyle(fontSize: 11, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndAddButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari nama pengguna...',
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: Icon(Icons.search, color: Colors.grey[600]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _showAddUserDialog,
            icon: const Icon(Icons.add, size: 20),
            label: const Text('User'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB923C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white70.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8)],
      ),
      child: Row(
        children: [
          _tabItem(index: 0, text: 'Petugas'),
          _tabItem(index: 1, text: 'Peminjam'),
        ],
      ),
    );
  }

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
            child: Text(text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xff2b2b2b))),
          ),
        ),
      ),
    );
  }
}
