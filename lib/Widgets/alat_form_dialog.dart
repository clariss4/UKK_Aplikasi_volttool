import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/kategori.dart';
import '../models/alat.dart';
import '../services/database_service.dart';

class AlatFormDialog extends StatefulWidget {
  final Alat? alat;
  final List<Kategori> kategoriList;

  const AlatFormDialog({super.key, this.alat, required this.kategoriList});

  @override
  State<AlatFormDialog> createState() => _AlatFormDialogState();
}

class _AlatFormDialogState extends State<AlatFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();
  final _picker = ImagePicker();

  late TextEditingController namaCtrl;
  late TextEditingController stokCtrl;

  String? kategoriId;
  String kondisi = 'baik';

  Uint8List? _fotoBytes; // Hanya untuk web (bytes gambar baru)
  String? _existingFotoUrl; // URL dari database (sudah ada sebelumnya)

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
    _existingFotoUrl = widget.alat?.fotoUrl;
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
              // Preview gambar real-time
              if (_existingFotoUrl != null || _fotoBytes != null)
                Container(
                  height: 150,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildImagePreview(),
                  ),
                ),

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _pilihFoto,
                icon: const Icon(Icons.camera_alt),
                label: Text(
                  _fotoBytes != null || _existingFotoUrl != null
                      ? 'Ganti Foto'
                      : 'Upload Foto',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C42),
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: kategoriId,
                items: widget.kategoriList
                    .map(
                      (k) => DropdownMenuItem<String>(
                        value: k.id,
                        child: Text(k.nama),
                      ),
                    )
                    .toList(),
                onChanged: _isLoading
                    ? null
                    : (v) => setState(() => kategoriId = v),
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'Pilih kategori' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: namaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Alat',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.trim().isEmpty ? 'Nama alat wajib diisi' : null,
                enabled: !_isLoading,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: stokCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stok Total',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v!.trim().isEmpty) return 'Stok wajib diisi';
                  final num = int.tryParse(v);
                  if (num == null) return 'Harus angka';
                  if (num < 0) return 'Tidak boleh negatif';
                  return null;
                },
                enabled: !_isLoading,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: kondisi,
                items: ['baik', 'rusak']
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e[0].toUpperCase() + e.substring(1)),
                      ),
                    )
                    .toList(),
                onChanged: _isLoading
                    ? null
                    : (v) => setState(() => kondisi = v!),
                decoration: const InputDecoration(
                  labelText: 'Kondisi',
                  border: OutlineInputBorder(),
                ),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF8C42),
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Simpan'),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (_fotoBytes != null) {
      return Image.memory(
        _fotoBytes!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 48),
      );
    }

    if (_existingFotoUrl != null) {
      return Image.network(
        _existingFotoUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 48),
      );
    }

    return const Center(
      child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
    );
  }

  Future<void> _pilihFoto() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _fotoBytes = bytes;
          _existingFotoUrl = null; // ganti preview ke yang baru
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih foto: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
        'nama_alat': namaCtrl.text.trim(),
        'stok_total': int.parse(stokCtrl.text.trim()),
        'kondisi': kondisi,
      };

      if (widget.alat == null) {
        data['stok_tersedia'] = data['stok_total'];
        await _db.insertAlat(data, fotoFile: _fotoBytes);
      } else {
        await _db.updateAlat(widget.alat!.id, data, fotoFile: _fotoBytes);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.alat == null
                  ? 'Alat berhasil ditambahkan'
                  : 'Alat berhasil diupdate',
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
