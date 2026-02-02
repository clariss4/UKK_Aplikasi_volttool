import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/kategori.dart';

class KategoriFormDialog extends StatefulWidget {
  final Kategori? kategori;

  const KategoriFormDialog({super.key, this.kategori});

  @override
  State<KategoriFormDialog> createState() => _KategoriFormDialogState();
}

class _KategoriFormDialogState extends State<KategoriFormDialog> {
  late TextEditingController namaController;
  late bool isActive;

  String? errorNama; // ✅ VALIDASI ERROR

  static const Color primaryOrange = Color(0xFFFF8C42);

  @override
  void initState() {
    super.initState();
    
    namaController = TextEditingController(
      text: widget.kategori?.namaKategori ?? '',
    );
    isActive = widget.kategori?.isActive ?? false;
  }

  void _submit() {
    setState(() {
      errorNama = null;

      if (namaController.text.trim().isEmpty) {
        errorNama = 'Nama kategori wajib diisi';
      }
    });

    if (errorNama != null) return;

    Navigator.pop(context, {
      'nama': namaController.text.trim(),
      'isActive': isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              widget.kategori == null ? 'Tambah Kategori' : 'Edit Kategori',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Silahkan tambahkan kategori baru',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            /// NAMA KATEGORI
            Text(
              'Nama Kategori',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: namaController,
              style: GoogleFonts.inter(fontSize: 13),
              cursorColor: primaryOrange,
              decoration: InputDecoration(
                hintText: 'Tambahkan nama kategori alat...',
                hintStyle: GoogleFonts.inter(fontSize: 12),
                isDense: true,
                errorText: errorNama,

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: primaryOrange,
                    width: 1.5,
                  ),
                ),

                // ✅ AGAR ERROR TETAP KOTAK (BUKAN GARIS)
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red, width: 1.2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Kategori akan di tampilkan di filter kategori',
              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            /// STATUS
            Text(
              'Status Kategori',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Non Aktif', style: GoogleFonts.inter(fontSize: 12)),
                const SizedBox(width: 8),
                Switch(
                  value: isActive,
                  activeColor: Colors.white,
                  activeTrackColor: primaryOrange,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade400,
                  onChanged: (v) => setState(() => isActive = v),
                ),
                const SizedBox(width: 8),
                Text('Aktif', style: GoogleFonts.inter(fontSize: 12)),
              ],
            ),

            const SizedBox(height: 32),

            /// ACTION BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// BATAL
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Batal',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(width: 12),

                /// SIMPAN
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: _submit,
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    super.dispose();
  }
}