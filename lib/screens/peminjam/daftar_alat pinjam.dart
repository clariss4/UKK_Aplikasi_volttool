import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DaftarAlatPage extends StatelessWidget {
  const DaftarAlatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentPage: 'Daftar Alat'),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFB923C),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        toolbarHeight: 110,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 35, left: 4),
          child: Text(
            'Daftar Alat\nPinjam',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(),
            const SizedBox(height: 12),
            _kategori(),
            const SizedBox(height: 20),
            const Text(
              'Alat Ukur',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  AlatCard(
                    tombolText: 'Ditolak',
                    tombolColor: Colors.orange,
                    tanggal: '10/01/2026',
                  ),
                  AlatCard(
                    tombolText: 'Kembalikan',
                    tombolColor: Colors.orange,
                    tanggal: '12/01/2026',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari alat atau kategori...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _kategori() {
    return Row(
      children: [
        _chip('Alat Ukur', true),
        const SizedBox(width: 8),
        _chip('Alat Solder', false),
        const SizedBox(width: 8),
        _chip('Alat Kerja listrik', false),
      ],
    );
  }

  Widget _chip(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.orange : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.orange,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class AlatCard extends StatelessWidget {
  final String tombolText;
  final Color tombolColor;
  final String tanggal;

  const AlatCard({
    super.key,
    required this.tombolText,
    required this.tombolColor,
    required this.tanggal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/1686/1686807.png',
              width: 60,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tang tangan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Pinjam : tang tangan 1 x'),
                  Text('Dikembalikan: $tanggal'),
                  const Text('Kondisi: Baik'),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: tombolColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {},
              child: Text(tombolText),
            ),
          ],
        ),
      ),
    );
  }
}
