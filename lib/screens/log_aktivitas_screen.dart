import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import '../models/log_aktivitas.dart';
import '../widgets/log_card.dart';
import '../data_dummy.dart'; // pastikan ini impor data dummy

class LogAktivitasPage extends StatefulWidget {
  const LogAktivitasPage({Key? key}) : super(key: key);

  @override
  State<LogAktivitasPage> createState() => _LogAktivitasPageState();
}

class _LogAktivitasPageState extends State<LogAktivitasPage> {
  final searchController = TextEditingController();
  String selectedFilter = 'Semua';
  DateTime? selectedDate;

  // Gunakan data dummy
  final logList = DummyData.logList;

  List<LogAktivitas> get filteredLogs {
    var filtered = logList;

    // ===================== FILTER PENCARIAN =====================
    if (searchController.text.isNotEmpty) {
      filtered = filtered
          .where(
            (log) =>
                log.namaUser.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ||
                log.aktivitas.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
          )
          .toList();
    }

    // ===================== FILTER KATEGORI =====================
    if (selectedFilter != 'Semua') {
      filtered = filtered.where((log) {
        switch (selectedFilter) {
          case 'Login/Logout':
            return log.aktivitas.toLowerCase().contains('login') ||
                log.aktivitas.toLowerCase().contains('logout');
          case 'Peminjaman':
            return log.aktivitas.toLowerCase().contains('pinjam') ||
                log.aktivitas.toLowerCase().contains('kembali');
          case 'Manajemen Alat':
            return log.aktivitas.toLowerCase().contains('alat');
          case 'Manajemen User':
            return log.aktivitas.toLowerCase().contains('user') ||
                log.aktivitas.toLowerCase().contains('pengguna');
          default:
            return true;
        }
      }).toList();
    }

    // ===================== FILTER TANGGAL =====================
    if (selectedDate != null) {
      filtered = filtered
          .where(
            (log) =>
                log.waktu.year == selectedDate!.year &&
                log.waktu.month == selectedDate!.month &&
                log.waktu.day == selectedDate!.day,
          )
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: AppDrawer(currentPage: 'Log Aktivitas'),
      appBar: _buildAppBar(),
      body: Column(
        children: [_buildSearchBar(), _buildFilterSection(), _buildLogList()],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFF8C42),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      toolbarHeight: 110,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 35, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Sistem', style: TextStyle(color: Colors.white, fontSize: 16)),
            Text(
              'Log Aktivitas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
                child: Icon(Icons.person, color: Color(0xFFFF8C42)),
              ),
              SizedBox(height: 4),
              Text(
                'Admin',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: const Color(0xFFFF8C42),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari aktivitas atau user...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: selectedDate != null
                    ? const Color(0xFFFF8C42)
                    : Colors.grey[600],
              ),
              onPressed: () => _selectDate(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip('Semua'),
          _buildFilterChip('Login/Logout'),
          _buildFilterChip('Peminjaman'),
          _buildFilterChip('Manajemen Alat'),
          _buildFilterChip('Manajemen User'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFFF8C42),
          ),
        ),
        selected: isSelected,
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFFF8C42),
        side: const BorderSide(color: Color(0xFFFF8C42)),
        onSelected: (_) {
          setState(() {
            selectedFilter = label;
          });
        },
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildLogList() {
    final logs = filteredLogs;
    return Expanded(
      child: logs.isEmpty
          ? Center(
              child: Text(
                'Tidak ada log aktivitas',
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) => LogCard(log: logs[index]),
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFFF8C42),
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
