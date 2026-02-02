import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:apk_peminjaman/Widgets/peminjaman_card.dart';
import 'package:apk_peminjaman/Widgets/pengembalian_manajemen_card.dart';
import 'package:apk_peminjaman/Widgets/perbarui_peminjaman_dialog.dart';
import 'package:apk_peminjaman/Widgets/perbarui_pengembalian_dialog.dart';
import 'package:apk_peminjaman/controllers/peminjaman_controller.dart';
import 'package:apk_peminjaman/controllers/pengembalian_controller.dart';
import 'package:apk_peminjaman/models/peminjaman.dart';
import 'package:apk_peminjaman/models/pengembalian.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManajemenPeminjamanScreen extends StatefulWidget {
  const ManajemenPeminjamanScreen({super.key});

  @override
  State<ManajemenPeminjamanScreen> createState() =>
      _ManajemenPeminjamanScreenState();
}

class _ManajemenPeminjamanScreenState extends State<ManajemenPeminjamanScreen> {
  static const Color primaryColor = Color(0xFFFB923C);
  static const Color bgColor = Color(0xFFF7F2EC);

  bool isPeminjamanTab = true;

  final PeminjamanController peminjamanController = PeminjamanController();
  final PengembalianController pengembalianController =
      PengembalianController();

  @override
  void initState() {
    super.initState();
    // Load data awal & subscribe realtime
    peminjamanController.loadPeminjaman();
    pengembalianController.loadPengembalian();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: AppDrawer(currentPage: "Manajemen Peminjaman & Pengembalian"),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search & Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari nama pengguna...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tab Switcher
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isPeminjamanTab = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isPeminjamanTab
                              ? primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Peminjaman',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isPeminjamanTab
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isPeminjamanTab = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isPeminjamanTab
                              ? primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Pengembalian',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !isPeminjamanTab
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // List Realtime
          Expanded(
            child: isPeminjamanTab
                ? _buildPeminjamanList()
                : _buildPengembalianList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      toolbarHeight: 110,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 35, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manajemen',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Peminjaman & Pengembalian',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeminjamanList() {
    return StreamBuilder<List<Peminjaman>>(
      stream: peminjamanController.streamPeminjaman,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Terjadi kesalahan saat memuat data',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final list = snapshot.data ?? [];

        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada data peminjaman',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tambahkan peminjaman baru untuk memulai',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PeminjamanCard(
                peminjaman: item,
                onLihat: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lihat detail peminjaman')),
                  );
                },
                onEdit: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        PerbaruiPeminjamanDialog(peminjaman: item),
                  );
                },
                onHapus: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Hapus Peminjaman?'),
                      content: const Text('Data akan dihapus permanen.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Hapus',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await peminjamanController.hapusPeminjaman(item.id);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPengembalianList() {
    return StreamBuilder<List<Pengembalian>>(
      stream: pengembalianController.streamPengembalian,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Terjadi kesalahan saat memuat data',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final list = snapshot.data ?? [];

        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada data pengembalian',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Proses pengembalian dari peminjaman untuk memulai',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PengembalianManajemenCard(
                pengembalian: item,
                onLihat: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lihat detail pengembalian')),
                  );
                },
                onEdit: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        PerbaruiPengembalianDialog(pengembalian: item),
                  );
                },
                onHapus: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Hapus Pengembalian?'),
                      content: const Text('Data akan dihapus permanen.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Hapus',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await pengembalianController.hapusPengembalian(item.id);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
