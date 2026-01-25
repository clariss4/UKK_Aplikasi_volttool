import 'package:flutter/material.dart';

class PerbaruiPengembalianDialog extends StatefulWidget {
  const PerbaruiPengembalianDialog({Key? key}) : super(key: key);

  @override
  State<PerbaruiPengembalianDialog> createState() => _PerbaruiPengembalianDialogState();
}

class _PerbaruiPengembalianDialogState extends State<PerbaruiPengembalianDialog> {
  String selectedKondisi = 'Baik';
  String selectedStatus = 'Dikembalikan';
  bool isAktif = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Perbarui Pengembalian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildDropdown('Kondisi', selectedKondisi, ['Baik', 'Rusak', 'Hilang'], (value) {
                setState(() {
                  selectedKondisi = value!;
                });
              }),
              const SizedBox(height: 16),
              _buildDropdown('Status', selectedStatus, ['Dikembalikan', 'Terlambat', 'Hilang'], (value) {
                setState(() {
                  selectedStatus = value!;
                });
              }),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Non Aktif'),
                  const SizedBox(width: 12),
                  Switch(
                    value: isAktif,
                    onChanged: (value) => setState(() => isAktif = value),
                    activeColor: const Color(0xFFD67A3E),
                  ),
                  const SizedBox(width: 12),
                  const Text('Aktif'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD67A3E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 13)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
