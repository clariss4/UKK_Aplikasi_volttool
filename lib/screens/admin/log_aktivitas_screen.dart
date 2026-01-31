import 'package:apk_peminjaman/Widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import '../../models/log_aktivitas.dart';
import '../../widgets/log_card.dart';
import '../../data_dummy.dart'; // pastikan ini impor data dummy

class LogAktivitasPage extends StatefulWidget {
  const LogAktivitasPage({Key? key}) : super(key: key);

  @override
  State<LogAktivitasPage> createState() => _LogAktivitasPageState();
}

class _LogAktivitasPageState extends State<LogAktivitasPage> {
  final searchController = TextEditingController();
  DateTime? selectedDate;

  // Gunakan data dummy
  final List<LogAktivitas> logList = DummyData.logList;

  // Filter logs berdasarkan pencarian dan tanggal
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
      body: Column(children: [_buildSearchBar(), _buildLogList()]),
    );
  }

  // ===================== APPBAR =====================
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
    );
  }

  // ===================== SEARCH BAR + DATE PICKER =====================
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
                onChanged: (_) => setState(() {}),
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

  // ===================== LOG LIST =====================
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

  // ===================== DATE PICKER =====================
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
