import 'package:flutter/material.dart';
import '../models/peminjaman.dart';
import '../controllers/peminjaman_controller.dart';

class PerbaruiPeminjamanDialog extends StatefulWidget {
  final Peminjaman peminjaman;

  const PerbaruiPeminjamanDialog({
    super.key,
    required this.peminjaman,
  });

  @override
  State<PerbaruiPeminjamanDialog> createState() => _PerbaruiPeminjamanDialogState();
}

class _PerbaruiPeminjamanDialogState extends State<PerbaruiPeminjamanDialog> {
  late String selectedStatus;
  bool _isLoading = false;

  final List<String> statusOptions = [
    'menunggu',
    'disetujui',
    'ditolak',
    'dipinjam',
    'dikembalikan',
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.peminjaman.status;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFFB923C);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perbarui Peminjaman',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Field readonly tanpa garis bawah tebal (hanya background abu)
            _buildReadOnlyField('Nama Peminjam', widget.peminjaman.namaPeminjam),
            const SizedBox(height: 16),
            _buildReadOnlyField('Username', widget.peminjaman.usernamePeminjam),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              'Tanggal Pinjam - Batas',
              '${widget.peminjaman.tanggalPinjam.toString().substring(0, 10)} - ${widget.peminjaman.batasPengembalian.toString().substring(0, 10)}',
            ),
            const SizedBox(height: 24),

            Text(
              'Status',
              style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: statusOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status[0].toUpperCase() + status.substring(1),
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: _isLoading ? null : (value) {
                if (value != null) setState(() => selectedStatus = value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  label: const Text('Hapus', style: TextStyle(color: Colors.red, fontSize: 14)),
                  onPressed: _isLoading ? null : () => _konfirmasiHapus(context),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Batal', style: TextStyle(fontSize: 14)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: _isLoading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.save, size: 18),
                      label: const Text('Simpan', style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isLoading ? null : () => _simpan(context),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

 Future<void> _simpan(BuildContext context) async {
  setState(() => _isLoading = true);

  final controller = PeminjamanController();

  await controller.updateStatus(  // ← cukup await saja, tanpa final success
    widget.peminjaman.id,
    selectedStatus,
  );

  setState(() => _isLoading = false);

  if (context.mounted) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Peminjaman berhasil diperbarui')),
    );
  }
}
  Future<void> _konfirmasiHapus(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Peminjaman?'),
        content: const Text('Data akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final controller = PeminjamanController();
      await controller.hapusPeminjaman(widget.peminjaman.id);
      Navigator.pop(context);
    }
  }
}