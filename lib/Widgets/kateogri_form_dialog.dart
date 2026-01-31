import 'package:flutter/material.dart';
import '../services/database_service.dart';

class KategoriFormDialog extends StatefulWidget {
  final Map<String, dynamic>?
  kategori; // ✅ Tetap Map untuk backward compatibility

  const KategoriFormDialog({super.key, this.kategori});

  @override
  State<KategoriFormDialog> createState() => _KategoriFormDialogState();
}

class _KategoriFormDialogState extends State<KategoriFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  late TextEditingController namaCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    namaCtrl = TextEditingController(text: widget.kategori?['nama_kategori']);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.kategori == null ? 'Tambah Kategori' : 'Edit Kategori',
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: namaCtrl,
          decoration: const InputDecoration(labelText: 'Nama Kategori'),
          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
          enabled: !_isLoading,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _simpan,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Simpan'),
        ),
      ],
    );
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {'nama_kategori': namaCtrl.text, 'is_active': true};

      if (widget.kategori == null) {
        await _db.insertKategori(data);
      } else {
        await _db.updateKategori(widget.kategori!['id'], data);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.kategori == null
                  ? 'Kategori berhasil ditambahkan'
                  : 'Kategori berhasil diupdate',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    super.dispose();
  }
}
