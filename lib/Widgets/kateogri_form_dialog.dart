import 'package:flutter/material.dart';
import '../models/kategori.dart';

class KategoriFormDialog extends StatefulWidget {
  final Kategori? kategori;
  
  const KategoriFormDialog({Key? key, this.kategori}) : super(key: key);

  @override
  State<KategoriFormDialog> createState() => _KategoriFormDialogState();
}

class _KategoriFormDialogState extends State<KategoriFormDialog> {
  late TextEditingController namaController;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.kategori?.nama ?? '');
    isActive = widget.kategori?.isActive ?? true;
  }

  void _showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red[600] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.kategori != null;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C42).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.category, color: Color(0xFFFF8C42), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    isEdit ? 'Edit Kategori' : 'Tambah Kategori',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: 'Nama Kategori',
                hintText: 'Masukkan nama kategori',
                prefixIcon: const Icon(Icons.label_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text('Status Aktif', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  isActive ? 'Kategori dapat digunakan' : 'Kategori tidak aktif',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                value: isActive,
                activeColor: const Color(0xFFFF8C42),
                onChanged: (value) => setState(() => isActive = value),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                    child: const Text('Batal', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (namaController.text.isEmpty) {
                        _showSnackBar('Nama kategori harus diisi', true);
                        return;
                      }

                      // TODO: Simpan/Update ke database
                      final kategoriData = {
                        'id': widget.kategori?.id ?? DateTime.now().toString(),
                        'nama_kategori': namaController.text,
                        'is_active': isActive,
                      };
                      
                      Navigator.pop(context, kategoriData);
                      _showSnackBar('Kategori berhasil ${isEdit ? "diupdate" : "ditambahkan"}', false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C42),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    child: Text(
                      isEdit ? 'Update' : 'Simpan',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

