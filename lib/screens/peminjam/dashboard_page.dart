
import 'package:apk_peminjaman/models/dashboard_peminjam.dart';
import 'package:apk_peminjaman/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // ================== WARNA (LANGSUNG DI FILE) ==================
  static const Color primaryColor = Color(0xFFF7931E);
  static const Color backgroundColor = Color(0xFFF8F3EE);
  static const Color successColor = Color(0xFF6EF38E);
  static const Color warningColor = Color(0xFFFFB36A);

  @override
  Widget build(BuildContext context) {
    final List<BorrowingModel> data = [
      BorrowingModel(
        name: 'Clarissa Aurelia QP',
        dateRange: '30 Jan 2026 - 01 Feb 2026',
        totalItem: 2,
        returnedDate: '02 Feb 2026',
        status: 'Denda Lunas',
        isLate: true,
      ),
      BorrowingModel(
        name: 'Clarissa Aurelia QP',
        dateRange: '30 Jan 2026 - 01 Feb 2026',
        totalItem: 2,
        status: 'Tepat Waktu',
      ),
      BorrowingModel(
        name: 'Clarissa Aurelia QP',
        dateRange: '30 Jan 2026 - 01 Feb 2026',
        totalItem: 2,
        status: 'Menunggu konfirmasi petugas',
      ),
    ];

    return Scaffold(
      drawer: AppDrawer(currentPage: 'Dashboard Peminjam'),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          _buildAppBar(),
          _buildSearchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _buildBorrowingCard(data[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================== APP BAR ==================
  Widget _buildAppBar() {
    return Container(
      height: 120,
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
      color: primaryColor,
      child: Row(
        children: const [
          Icon(Icons.menu, color: Colors.white),
          SizedBox(width: 16),
          Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================== SEARCH BAR ==================
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari alat atau kategori...',
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.search, color: Colors.grey),
        ],
      ),
    );
  }

  // ================== BORROWING CARD ==================
  Widget _buildBorrowingCard(BorrowingModel data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          Text(data.dateRange),
          const SizedBox(height: 6),
          Text('Total Alat : ${data.totalItem}'),

          if (data.returnedDate != null) ...[
            const SizedBox(height: 6),
            Text('Dikembalikan : ${data.returnedDate}'),
          ],

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Status: ${data.status}',
                  style: TextStyle(
                    color: _statusTextColor(data.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildStatusBadge(data.status),
            ],
          ),

          if (data.isLate) ...[
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.warning, color: Colors.red, size: 16),
                SizedBox(width: 6),
                Text('Terlambat 1 hari', style: TextStyle(color: Colors.red)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ================== STATUS HELPER ==================
  Color _statusTextColor(String status) {
    if (status.contains('Tepat')) return Colors.green;
    if (status.contains('Denda')) return Colors.green;
    return Colors.orange;
  }

  Widget _buildStatusBadge(String status) {
    final bool isWaiting = status.contains('Menunggu');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isWaiting ? warningColor : successColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isWaiting ? 'Menunggu' : 'Selesai',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
