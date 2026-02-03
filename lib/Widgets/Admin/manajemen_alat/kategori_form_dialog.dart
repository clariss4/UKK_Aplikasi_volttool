import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/kategori.dart';

class KategoriFormDialog extends StatefulWidget {
  final Kategori? kategori;

  const KategoriFormDialog({super.key, this.kategori});

  @override
  State<KategoriFormDialog> createState() => _KategoriFormDialogState();
}

class _KategoriFormDialogState extends State<KategoriFormDialog> {
  late TextEditingController namaController;
  late bool isActive;

  String? errorNama;
  bool isSubmitting = false;

  static const Color primaryOrange = Color(0xFFFF8C42);

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(
      text: widget.kategori?.namaKategori ?? '',
    );
    isActive = widget.kategori?.isActive ?? true;
  }

  bool _validate() {
    bool valid = true;
    errorNama = null;

    if (namaController.text.trim().isEmpty) {
      errorNama = 'Nama kategori wajib diisi';
      valid = false;
    }

    setState(() {});
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.kategori == null ? 'Tambah Kategori' : 'Edit Kategori',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.kategori == null
                  ? 'Silahkan tambahkan kategori baru'
                  : 'Edit informasi kategori',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Nama Kategori
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
                hintText: 'Masukkan nama kategori',
                isDense: true,
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
              ),
            ),
            if (errorNama != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  errorNama!,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.red,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Status
            Text(
              'Status Kategori',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
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

            // Action Buttons
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
                            'nama_kategori': namaController.text.trim(),
                            'is_active': isActive,
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
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

  @override
  void dispose() {
    namaController.dispose();
    super.dispose();
  }
}