import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/peminjaman.dart';
import '../controllers/pengembalian_controller.dart';

class PengembalianPeminjamanDialog extends StatefulWidget {
  final Peminjaman peminjaman;

  const PengembalianPeminjamanDialog({super.key, required this.peminjaman});

  @override
  State<PengembalianPeminjamanDialog> createState() => _PengembalianPeminjamanDialogState();
}

class _PengembalianPeminjamanDialogState extends State<PengembalianPeminjamanDialog> {
  late String selectedKondisi;
  DateTime tanggalKembali = DateTime.now();
  bool _isLoading = false;

  final List<String> kondisiOptions = ['Baik', 'Rusak', 'Hilang'];

  @override
  void initState() {
    super.initState();
    selectedKondisi = 'Baik';
  }

  bool get _terlambat => tanggalKembali.isAfter(widget.peminjaman.batasPengembalian);

  int get _hariTerlambat => _terlambat ? tanggalKembali.difference(widget.peminjaman.batasPengembalian).inDays : 0;

  String get _dendaText {
    if (!_terlambat) return '-';
    final jumlah = _hariTerlambat * 5000;
    return 'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(jumlah)} (terlambat $_hariTerlambat hari)';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFFB923C);
    final formatter = DateFormat('dd/MM/yyyy');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengembalian Alat',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Text(
                widget.peminjaman.namaPeminjam,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Username: ${widget.peminjaman.usernamePeminjam}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),

              _buildReadOnlyRow('Tanggal Pinjam', formatter.format(widget.peminjaman.tanggalPinjam)),
              _buildReadOnlyRow('Batas Pengembalian', formatter.format(widget.peminjaman.batasPengembalian)),

              const SizedBox(height: 20),

              Text('Tanggal Dikembalikan', style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _isLoading ? null : () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: tanggalKembali,
                    firstDate: widget.peminjaman.tanggalPinjam,
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != tanggalKembali) {
                    setState(() => tanggalKembali = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatter.format(tanggalKembali), style: const TextStyle(fontSize: 14)),
                      Icon(Icons.calendar_today, color: primaryColor),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text('Kondisi Alat', style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedKondisi,
                items: kondisiOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: _isLoading ? null : (v) => setState(() => selectedKondisi = v!),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),

              const SizedBox(height: 24),

              if (_terlambat || _hariTerlambat > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('Terlambat', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Denda: $_dendaText', style: const TextStyle(color: Colors.red, fontSize: 14)),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Batal', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                  ElevatedButton.icon(
                    icon: _isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save, size: 18),
                    label: const Text('Simpan Pengembalian', style: TextStyle(fontSize: 14)),
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
        ),
      ),
    );
  }

  Widget _buildReadOnlyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Future<void> _simpan(BuildContext context) async {
    setState(() => _isLoading = true);

    final controller = PengembalianController();

    await controller.tambahPengembalian(
      peminjamanId: widget.peminjaman.id,
      petugasId: 'current_user_id',
      tanggalKembali: tanggalKembali,
      kondisi: selectedKondisi.toLowerCase(),
      batasPengembalian: widget.peminjaman.batasPengembalian,
      context: context,
    );

    setState(() => _isLoading = false);

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengembalian berhasil disimpan')),
      );
    }
  }
}