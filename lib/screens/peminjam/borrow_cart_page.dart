import 'package:apk_peminjaman/screens/peminjam/borrow_succes_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/borrow_cart_controller.dart';
import '../../controllers/peminjaman_submit_controller.dart';

class BorrowCartPage extends StatefulWidget {
  const BorrowCartPage({super.key});

  @override
  State<BorrowCartPage> createState() => _BorrowCartPageState();
}

class _BorrowCartPageState extends State<BorrowCartPage> {
  DateTime batasPengembalian = DateTime.now().add(const Duration(days: 1));
  String kondisi = 'baik';

  String namaLengkap = '';
String username = '';


  @override
  void initState() {
    super.initState();
    _loadUser();
  }

 Future<void> _loadUser() async { 
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    namaLengkap =
        prefs.getString('name') ?? 'Nama Peminjam';
    username =
        prefs.getString('username') ?? 'username';
  });

  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<BorrowCartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EC),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 120,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Detail Peminjaman',
          style: GoogleFonts.inter(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ================= INFORMASI PEMINJAM =================
            _sectionCard(
              title: 'Informasi Peminjam',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama : $namaLengkap'),
                  const SizedBox(height: 4),
                  Text('Username : $username'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// ================= BATAS PEMINJAMAN =================
            _sectionCard(
              title: 'Batas Peminjaman',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tanggal Pinjam : ${_fmt(DateTime.now())}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 18),
                      const SizedBox(width: 8),
                      const Text('Batas Pengembalian: '),
                      InkWell(
                        onTap: _pickDate,
                        child: Text(
                          _fmt(batasPengembalian),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// ================= KONDISI =================
            _sectionCard(
              title: 'Pilih Kondisi Barang',
              child: Column(
                children: [
                  RadioListTile(
                    value: 'baik',
                    groupValue: kondisi,
                    title: const Text('Baik'),
                    onChanged: (v) => setState(() => kondisi = v!),
                  ),
                  RadioListTile(
                    value: 'rusak_ringan',
                    groupValue: kondisi,
                    title: const Text('Rusak Ringan'),
                    onChanged: (v) => setState(() => kondisi = v!),
                  ),
                  RadioListTile(
                    value: 'rusak_berat',
                    groupValue: kondisi,
                    title: const Text('Rusak Berat'),
                    onChanged: (v) => setState(() => kondisi = v!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// ================= DAFTAR ALAT =================
            Expanded(
              child: _sectionCard(
                title: 'Daftar Alat Pinjaman',
                child: Column(
                  children: cart.items.map((item) {
                    return ListTile(
                      title: Text(item.nama),
                      subtitle: Text('Jumlah: ${item.qty}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () =>
                                context.read<BorrowCartController>().decrease(
                                      item.id,
                                    ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () =>
                                context.read<BorrowCartController>().increase(
                                      item.id,
                                    ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ================= SUBMIT =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cart.items.isEmpty
                    ? null
                    : () async {
                        final success = await PeminjamanSubmitController().submit(
  context: context,
  cart: cart,
  batasPengembalian: batasPengembalian,
  kondisi: kondisi,
);

if (success && mounted) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const BorrowSuccessPage(),
    ),
  );
}

                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Ajukan Peminjaman',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= DATE PICKER =================
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: batasPengembalian,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => batasPengembalian = picked);
    }
  }

  /// ================= HELPERS =================
  String _fmt(DateTime d) {
    return '${d.day} ${_bulan(d.month)} ${d.year}';
  }

  String _bulan(int m) {
    const list = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return list[m - 1];
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
