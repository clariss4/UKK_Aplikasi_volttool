import 'package:flutter/material.dart';
import '../services/database_service.dart';

class AlatFormDialog extends StatefulWidget {
  final Map<String, dynamic>? alat;
  final List<Map<String, dynamic>> kategoriList;

  const AlatFormDialog({super.key, this.alat, required this.kategoriList});

  @override
  State<AlatFormDialog> createState() => _AlatFormDialogState();
}

class _AlatFormDialogState extends State<AlatFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  late TextEditingController namaCtrl;
  late TextEditingController stokCtrl;

  String? kategoriId;
  String kondisi = 'Baik';

  @override
  void initState() {
    super.initState();
    namaCtrl = TextEditingController(text: widget.alat?['nama_alat']);
    stokCtrl = TextEditingController(
      text: widget.alat?['stok_total']?.toString(),
    );
    kategoriId = widget.alat?['kategori_id'];
    kondisi = widget.alat?['kondisi'] ?? 'Baik';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.alat == null ? 'Tambah Alat' : 'Edit Alat'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: kategoriId,
                items: widget.kategoriList
                    .map<DropdownMenuItem<String>>(
                      (k) => DropdownMenuItem<String>(
                        value: k['id'] as String,
                        child: Text(k['nama_kategori'] as String),
                      ),
                    )
                    .toList(),
                onChanged: (String? v) {
                  setState(() => kategoriId = v);
                },
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (v) => v == null ? 'Pilih kategori' : null,
              ),

              TextFormField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama Alat'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: stokCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stok Total'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              DropdownButtonFormField<String>(
                value: kondisi,
                items: ['Baik', 'Rusak', 'Perbaikan']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => kondisi = v!),
                decoration: const InputDecoration(labelText: 'Kondisi'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          child: const Text('Simpan'),
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            final data = {
              'kategori_id': kategoriId,
              'nama_alat': namaCtrl.text,
              'stok_total': int.parse(stokCtrl.text),
              'stok_tersedia': int.parse(stokCtrl.text),
              'kondisi': kondisi,
            };

            if (widget.alat == null) {
              await _db.insertAlat(data);
            } else {
              await _db.updateAlat(widget.alat!['id'], data);
            }

            if (mounted) Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
