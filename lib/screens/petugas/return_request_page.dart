import 'package:apk_peminjaman/Widgets/Petugas/pengembalian/filter_request.dart';
import 'package:apk_peminjaman/Widgets/Petugas/pengembalian/return_card.dart';
import 'package:flutter/material.dart';
import '../../widgets/main_drawer.dart';


class ReturnRequestPage extends StatefulWidget {
  const ReturnRequestPage({super.key});

  @override
  State<ReturnRequestPage> createState() => _ReturnRequestPageState();
}

class _ReturnRequestPageState extends State<ReturnRequestPage> {
  String selectedFilter = 'Dipinjam';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentPage: 'Permintaan pengembalian'),
      backgroundColor: const Color(0xFFF7F2EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFB923C),
        title: const Text('Permintaan Pengembalian'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari permintaan...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.search, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  width: 140,
                  child: RequestFilter(
                    selectedValue: selectedFilter,
                    onChanged: (val) {
                      setState(() => selectedFilter = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  ReturnCard(),
                  ReturnCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
