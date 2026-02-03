import 'dart:io';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/alat.dart';
import '../../../models/kategori.dart';

class AlatFormDialog extends StatefulWidget {
  final Alat? alat;
  final List<Kategori> kategoriList;

  const AlatFormDialog({super.key, this.alat, required this.kategoriList});

  @override
  State<AlatFormDialog> createState() => _AlatFormDialogState();
}

class _AlatFormDialogState extends State<AlatFormDialog> {
  late TextEditingController namaController;
  late TextEditingController kondisiController;
  late TextEditingController stokTotalController;
  late TextEditingController stokTersediaController;
  late bool isActive;

  String? selectedKategoriId;

  String? errorNama;
  String? errorKategori;
  String? errorStokTotal;
  String? errorStokTersedia;
  String? errorFoto;
  String? errorStatus;

  bool isSubmitting = false;

  static const Color primaryOrange = Color(0xFFFF8C42);

  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  Uint8List? imageBytes;
  String? existingFotoUrl; // ✅ Menyimpan foto URL yang sudah ada

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.alat?.namaAlat ?? '');
    kondisiController = TextEditingController(
      text: widget.alat?.kondisi ?? 'baik',
    );
    stokTotalController = TextEditingController(
      text: widget.alat?.stokTotal.toString() ?? '',
    );
    stokTersediaController = TextEditingController(
      text: widget.alat?.stokTersedia.toString() ?? '',
    );
    isActive = widget.alat?.isActive ?? true; // ✅ Default true untuk edit
    selectedKategoriId = widget.alat?.kategoriId;
    existingFotoUrl = widget.alat?.fotoUrl; // ✅ Simpan foto URL yang sudah ada
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    if (kIsWeb) {
      imageBytes = await picked.readAsBytes();
      imageFile = null;
    } else {
      imageFile = File(picked.path);
      imageBytes = null;
    }

    setState(() {
      errorFoto = null;
      existingFotoUrl = null; // ✅ Clear existing foto jika pilih foto baru
    });
  }

  bool _validate() {
    bool valid = true;

    errorNama = null;
    errorKategori = null;
    errorStokTotal = null;
    errorStokTersedia = null;
    errorFoto = null;
    errorStatus = null;

    if (namaController.text.trim().isEmpty) {
      errorNama = 'Nama alat wajib diisi';
      valid = false;
    }

    if (selectedKategoriId == null) {
      errorKategori = 'Kategori wajib dipilih';
      valid = false;
    }

    if (stokTotalController.text.isEmpty ||
        int.tryParse(stokTotalController.text) == null) {
      errorStokTotal = 'Stok harus berupa angka';
      valid = false;
    }

    if (stokTersediaController.text.isEmpty ||
        int.tryParse(stokTersediaController.text) == null) {
      errorStokTersedia = 'Stok harus berupa angka';
      valid = false;
    }

    /// ✅ FOTO WAJIB HANYA SAAT TAMBAH
    if (widget.alat == null && imageFile == null && imageBytes == null) {
      errorFoto = 'Foto wajib ditambahkan';
      valid = false;
    }

    setState(() {});
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.alat == null ? 'Tambah Alat' : 'Edit Alat',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.alat == null
                  ? 'Silahkan tambahkan alat baru'
                  : 'Edit informasi alat',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            /// FOTO - ✅ Tampilkan existing foto saat edit
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _pickImage,
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        borderRadius: BorderRadius.circular(8),
                        image: _getImageDecoration(),
                      ),
                      child: _getImageChild(),
                    ),
                    if (errorFoto != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          errorFoto!,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _label('Nama Alat'),
            _input(namaController, 'Tambahkan nama alat'),
            if (errorNama != null) _errorText(errorNama!),

            const SizedBox(height: 16),

            _label('Kategori'),
            DropdownButtonFormField<String>(
              value: selectedKategoriId,
              items: widget.kategoriList.map((kategori) {
                return DropdownMenuItem<String>(
                  value: kategori.id,
                  child: Text(
                    kategori.namaKategori,
                    style: GoogleFonts.inter(fontSize: 13),
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => selectedKategoriId = v),
              decoration: _dropdownDecoration(),
            ),
            if (errorKategori != null) _errorText(errorKategori!),

            const SizedBox(height: 16),

            _label('Kondisi'),
            DropdownButtonFormField<String>(
              value: kondisiController.text,
              items: const [
                DropdownMenuItem(value: 'baik', child: Text('Baik')),
                DropdownMenuItem(value: 'rusak', child: Text('Rusak')),
              ],
              onChanged: (v) => setState(() => kondisiController.text = v!),
              decoration: _dropdownDecoration(),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Stok Alat'),
                      _input(
                        stokTotalController,
                        '0',
                        keyboard: TextInputType.number,
                      ),
                      if (errorStokTotal != null) _errorText(errorStokTotal!),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Stok tersedia'),
                      _input(
                        stokTersediaController,
                        '0',
                        keyboard: TextInputType.number,
                      ),
                      if (errorStokTersedia != null)
                        _errorText(errorStokTersedia!),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _label('Status Alat'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Non Aktif'),
                Switch(
                  value: isActive,
                  activeColor: Colors.white,
                  activeTrackColor: primaryOrange,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade400,
                  onChanged: (v) => setState(() => isActive = v),
                ),
                const Text('Aktif'),
              ],
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (!_validate()) return;

                          setState(() => isSubmitting = true);
                          await Future.delayed(
                            const Duration(milliseconds: 100),
                          );

                          if (!mounted) return;

                          Navigator.pop(context, {
                            'namaAlat': namaController.text.trim(),
                            'kategoriId': selectedKategoriId,
                            'kondisi': kondisiController.text,
                            'stokTotal': int.parse(stokTotalController.text),
                            'stokTersedia': int.parse(
                              stokTersediaController.text,
                            ),
                            'isActive': isActive,
                            'imageFile': imageFile,
                            'imageBytes': imageBytes,
                            'fotoFile': imageFile ?? imageBytes,
                          });
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Helper untuk mendapatkan DecorationImage
  DecorationImage? _getImageDecoration() {
    // Prioritas: foto baru > foto existing
    if (imageBytes != null) {
      return DecorationImage(
        image: MemoryImage(imageBytes!),
        fit: BoxFit.cover,
      );
    } else if (imageFile != null) {
      return DecorationImage(image: FileImage(imageFile!), fit: BoxFit.cover);
    } else if (existingFotoUrl != null && existingFotoUrl!.isNotEmpty) {
      return DecorationImage(
        image: NetworkImage(existingFotoUrl!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  /// ✅ Helper untuk mendapatkan child widget (icon camera jika tidak ada foto)
  Widget? _getImageChild() {
    if (imageBytes == null && imageFile == null && existingFotoUrl == null) {
      return const Icon(Icons.camera_alt, color: Colors.grey);
    }
    return null;
  }

  InputDecoration _dropdownDecoration() => InputDecoration(
    isDense: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: primaryOrange, width: 1.5),
    ),
  );

  Widget _label(String text) => Text(
    text,
    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
  );

  Widget _errorText(String text) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      text,
      style: GoogleFonts.inter(fontSize: 11, color: Colors.red),
    ),
  );

  Widget _input(
    TextEditingController c,
    String hint, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      keyboardType: keyboard,
      style: GoogleFonts.inter(fontSize: 13),
      cursorColor: primaryOrange,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryOrange, width: 1.5),
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    kondisiController.dispose();
    stokTotalController.dispose();
    stokTersediaController.dispose();
    super.dispose();
  }
}
