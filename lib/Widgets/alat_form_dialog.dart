// ==================== FILE: lib/widgets/alat_form_dialog.dart ====================
// GANTI BAGIAN INI SAJA!!!

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/kategori.dart';
import '../models/alat.dart';
import '../services/database_service.dart';

class AlatFormDialog extends StatefulWidget {
  final Alat? alat;  // ← INI SUDAH BENAR
  final List<Kategori> kategoriList;  // ← INI SUDAH BENAR

  const AlatFormDialog({
    super.key,
    this.alat,
    required this.kategoriList,
  });

  @override
  State<AlatFormDialog> createState() => _AlatFormDialogState();
}

// SISANYA SAMA PERSIS SEPERTI SEBELUMNYA
class _AlatFormDialogState extends State<AlatFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();
  final _picker = ImagePicker();

  late TextEditingController namaCtrl;
  late TextEditingController stokCtrl;

  String? kategoriId;
  String kondisi = 'baik';
  File? _fotoFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    namaCtrl = TextEditingController(text: widget.alat?.nama ?? '');
    stokCtrl = TextEditingController(
      text: widget.alat?.stokTotal.toString() ?? '',
    );
    kategoriId = widget.alat?.kategoriId;
    kondisi = widget.alat?.kondisi ?? 'baik';
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
              if (widget.alat?.fotoUrl != null || _fotoFile != null)
                Container(
                  height: 150,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _fotoFile != null
                        ? Image.file(_fotoFile!, fit: BoxFit.cover)
                        : widget.alat?.fotoUrl != null
                            ? Image.network(
                                widget.alat!.fotoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image, size: 48),
                              )
                            : const SizedBox(),
                  ),
                ),

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _pilihFoto,
                icon: const Icon(Icons.camera_alt),
                label: Text(
                  _fotoFile != null || widget.alat?.fotoUrl != null
                      ? 'Ganti Foto'
                      : 'Upload Foto',
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: kategoriId,
                items: widget.kategoriList
                    .map((k) => DropdownMenuItem<String>(
                          value: k.id,
                          child: Text(k.nama),
                        ))
                    .toList(),
                onChanged: _isLoading
                    ? null
                    : (v) {
                        setState(() => kategoriId = v);
                      },
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (v) => v == null ? 'Pilih kategori' : null,
              ),

              TextFormField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama Alat'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                enabled: !_isLoading,
              ),

              TextFormField(
                controller: stokCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stok Total'),
                validator: (v) {
                  if (v!.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(v) == null) return 'Harus angka';
                  if (int.parse(v) < 0) return 'Tidak boleh negatif';
                  return null;
                },
                enabled: !_isLoading,
              ),

              DropdownButtonFormField<String>(
                value: kondisi,
                items: ['baik', 'rusak']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e[0].toUpperCase() + e.substring(1)),
                        ))
                    .toList(),
                onChanged: _isLoading ? null : (v) => setState(() => kondisi = v!),
                decoration: const InputDecoration(labelText: 'Kondisi'),
              ),
            ],
          ),
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

  Future<void> _pilihFoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _fotoFile = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error memilih foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'kategori_id': kategoriId,
        'nama_alat': namaCtrl.text,
        'stok_total': int.parse(stokCtrl.text),
        'stok_tersedia': widget.alat == null
            ? int.parse(stokCtrl.text)
            : widget.alat!.stokTersedia,
        'kondisi': kondisi,
        'is_active': true,
      };

      if (widget.alat == null) {
        await _db.insertAlat(data, fotoFile: _fotoFile);
      } else {
        await _db.updateAlat(widget.alat!.id, data, fotoFile: _fotoFile);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.alat == null
                ? 'Alat berhasil ditambahkan'
                : 'Alat berhasil diupdate'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    stokCtrl.dispose();
    super.dispose();
  }
}