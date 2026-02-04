import 'package:flutter/material.dart';
import '../../models/log_aktivitas.dart';
import '../../services/database_service.dart';
import '../../widgets/log_card.dart';
import 'package:apk_peminjaman/Widgets/main_drawer.dart';

class LogAktivitasPage extends StatefulWidget {
  const LogAktivitasPage({Key? key}) : super(key: key);

  @override
  State<LogAktivitasPage> createState() => _LogAktivitasPageState();
}

class _LogAktivitasPageState extends State<LogAktivitasPage> {
  final DatabaseService _db = DatabaseService();

  final searchController = TextEditingController();
  DateTime? selectedDate;

  // filter logs berdasarkan search + tanggal
  List<LogAktivitas> filterLogs(List<LogAktivitas> logs) {
    var filtered = logs;

    // SEARCH
    final q = searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered.where((log) {
        return log.namaUser.toLowerCase().contains(q) ||
            log.aktivitas.toLowerCase().contains(q);
      }).toList();
    }

    // FILTER TANGGAL
    if (selectedDate != null) {
      filtered = filtered.where((log) {
        final w = log.waktu;
        final d = selectedDate!;
        return w.year == d.year && w.month == d.month && w.day == d.day;
      }).toList();
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
        children: [
          _buildSearchBar(),
          Expanded(
            child: StreamBuilder<List<LogAktivitas>>(
              // pakai view agar nama user selalu ada realtime
              stream: _db.streamLogAktivitasView(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  );
                }

                final logs = filterLogs(snapshot.data ?? []);

                if (logs.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada log aktivitas',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: logs.length,
                  itemBuilder: (context, index) => LogCard(log: logs[index]),
                );
              },
            ),
          ),
        ],
      ),
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
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
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
          if (selectedDate != null) ...[
            const SizedBox(width: 6),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                tooltip: 'Reset tanggal',
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => setState(() => selectedDate = null),
              ),
            ),
          ],
        ],
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

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
