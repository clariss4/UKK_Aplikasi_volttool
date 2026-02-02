import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/kategori.dart';

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

  Future<void> _submit() async {
    setState(() {
      errorNama = null;
      isSubmitting = true;

      if (namaController.text.trim().isEmpty) {
        errorNama = 'Nama kategori wajib diisi';
        isSubmitting = false;
      }
    });

    if (errorNama != null) return;

    /// KONFIRMASI JIKA NONAKTIF
    if (widget.kategori != null &&
        widget.kategori!.isActive == true &&
        isActive == false) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Nonaktifkan Kategori?',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: Text(
            'Semua alat dalam kategori "${widget.kategori!.namaKategori}" '
            'juga akan dinonaktifkan. Lanjutkan?',
            style: GoogleFonts.inter(fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Batal',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Ya, Nonaktifkan',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirm != true) {
        setState(() => isSubmitting = false);
        return;
      }
    }

    /// ⬇⬇⬇ INI INTI PERBAIKANNYA ⬇⬇⬇
    Navigator.pop(context, {
      'nama_kategori': namaController.text.trim(),
      'is_active': isActive,
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
              widget.kategori == null
                  ? 'Silahkan tambahkan kategori baru'
                  : 'Edit informasi kategori',
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
              'Kategori akan ditampilkan di filter kategori',
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
                OutlinedButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
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
                ElevatedButton(
                  onPressed: isSubmitting ? null : _submit,
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
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
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
