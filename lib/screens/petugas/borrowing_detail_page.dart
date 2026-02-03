import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BorrowingDetailPage extends StatelessWidget {
  const BorrowingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1EB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 120,
        centerTitle: true,
        title:  Text(
          'Detail Permintaan',
          style:GoogleFonts.inter
          (fontWeight: FontWeight.w800),
        ),
      ),

      // ===== FOOTER BUTTON =====
      bottomNavigationBar: Container(
  padding: const EdgeInsets.fromLTRB(16, 44, 16, 48),
  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 10,
        offset: const Offset(0, -2),
      ),
    ],
  ),
  child: Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Tolak',
            style: TextStyle(fontWeight: FontWeight.w600,
            color: Colors.white),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Setujui',
            style: TextStyle(fontWeight: FontWeight.w600,
            color: Colors.white),
          ),
        ),
      ),
    ],
  ),
),


      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            title: 'Informasi Peminjam',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Nama : Clarissa Aurelia Qurnia Putri'),
                SizedBox(height: 6),
                Text('Username : clarissa456@volttool.com'),
              ],
            ),
          ),

          _section(
            title: 'Informasi Peminjaman',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _rowInfo('Tanggal Pinjam', '30 Jan 2026'),
                _rowInfo('Batas Pengembalian', '1 Feb 2026'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text('Status'),
                    const SizedBox(width: 8),
                    _statusChip('Menunggu'),
                  ],
                ),
              ],
            ),
          ),

          _section(
            title: 'Daftar Alat',
            child: Column(
              children: const [
                _AlatItem(
                  nama: 'Tang Tangan',
                  diminta: 1,
                  tersedia: 25,
                  cukup: true,
                ),
                Divider(),
                _AlatItem(
                  nama: 'Multimeter',
                  diminta: 1,
                  tersedia: 0,
                  cukup: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================== COMPONENT ==================

  Widget _section({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFE3C5),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFB923C),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _rowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFB923C),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ================== ALAT ITEM ==================

class _AlatItem extends StatelessWidget {
  final String nama;
  final int diminta;
  final int tersedia;
  final bool cukup;

  const _AlatItem({
    required this.nama,
    required this.diminta,
    required this.tersedia,
    required this.cukup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                nama,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text('Diminta: $diminta'),
            const SizedBox(width: 12),
            Text('Tersedia: $tersedia'),
            const SizedBox(width: 12),
            Text(
              cukup ? 'Aktif' : 'Tidak Cukup',
              style: TextStyle(
                color: cukup ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (!cukup)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Stok Tidak Cukup',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
