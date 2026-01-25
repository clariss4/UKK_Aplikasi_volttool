import 'package:flutter/material.dart';
import 'package:apk_peminjaman/Widgets/main_drawer.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentPage: 'Laporan'),
      backgroundColor: const Color(0xFFF7F2EC),

      // ================= HEADER =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFFB923C),
          titleSpacing: 0,
          title: const Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              'Laporan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 12),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFFFB923C)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Petugas',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SEARCH BAR
            Container(
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
                        hintText: 'Cari permintaan pinjaman...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // FILTER TANGGAL
            Row(
              children: [
                _dateDropdown('DD'),
                const SizedBox(width: 8),
                _dateDropdown('MM'),
                const SizedBox(width: 8),
                _dateDropdown('YYYY'),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Laporan Hari ini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            // TABLE HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E2DE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Peminjam',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Denda',
                      style: TextStyle(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // TABLE BODY
            Expanded(
              child: ListView(
                children: const [
                  ReportRow(status: 'Dikembalikan', fine: '-'),
                  ReportRow(status: 'Dikembalikan', fine: '-'),
                  ReportRow(status: 'Dikembalikan', fine: '-'),
                  ReportRow(status: 'Terlambat', fine: 'Rp 5.000'),
                  ReportRow(status: 'Dikembalikan', fine: '-'),
                  ReportRow(status: 'Dikembalikan', fine: '-'),
                  ReportRow(status: 'Dikembalikan', fine: '-'),
                  ReportRow(status: 'Terlambat', fine: 'Rp 5.000'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // BUTTON CETAK
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFB7C12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Cetak Laporan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ================= DATE DROPDOWN UI =================
  Widget _dateDropdown(String label) {
    return Expanded(
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFB7C12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// ====================== TABLE ROW ==================================
// ===================================================================

class ReportRow extends StatelessWidget {
  final String status;
  final String fine;

  const ReportRow({
    super.key,
    required this.status,
    required this.fine,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          const Expanded(
            flex: 4,
            child: Text('Clarissa Aurelia'),
          ),
          Expanded(
            flex: 3,
            child: Text(status),
          ),
          Expanded(
            flex: 2,
            child: Text(
              fine,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
