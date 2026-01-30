import 'package:flutter/material.dart';
import '../services/database_service.dart';

class KategoriFormDialog extends StatefulWidget {
  final Map<String, dynamic>? kategori;

  const KategoriFormDialog({super.key, this.kategori});

  @override
  State<KategoriFormDialog> createState() => _KategoriFormDialogState();
}

class _KategoriFormDialogState extends State<KategoriFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  late TextEditingController namaCtrl;

  @override
  void initState() {
    super.initState();
    namaCtrl =
        TextEditingController(text: widget.kategori?['nama_kategori']);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.kategori == null
          ? 'Tambah Kategori'
          : 'Edit Kategori'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: namaCtrl,
          decoration: const InputDecoration(labelText: 'Nama Kategori'),
          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            final data = {'nama_kategori': namaCtrl.text};

            if (widget.kategori == null) {
              await _db.insertKategori(data);
            } else {
              await _db.updateKategori(widget.kategori!['id'], data);
            }

            if (mounted) Navigator.pop(context);
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
