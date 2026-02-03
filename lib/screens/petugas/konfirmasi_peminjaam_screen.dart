import 'package:apk_peminjaman/Widgets/Petugas/peminjaman/borrowing_card.dart';
import 'package:apk_peminjaman/Widgets/Petugas/peminjaman/search_bar.dart';
import 'package:apk_peminjaman/Widgets/Petugas/peminjaman/status_filter.dart';
import 'package:flutter/material.dart';
import 'package:apk_peminjaman/Widgets/main_drawer.dart';


class BorrowingPage extends StatelessWidget {
  const BorrowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1EB),
      drawer: AppDrawer(currentPage: 'Konfirmasi Peminjaman'),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFB923C),
        elevation: 0,
        toolbarHeight: 120,
        title: const Text(
          'Permintaan peminjaman',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(child: SearchBarWidget()),
                SizedBox(width: 10),
                StatusFilter(),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  BorrowingCard(),
                  BorrowingCard(),
                  BorrowingCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
