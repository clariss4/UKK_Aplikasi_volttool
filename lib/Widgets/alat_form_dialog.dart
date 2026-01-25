import 'package:flutter/material.dart';
import '../models/alat.dart';
import '../models/kategori.dart';

class AlatFormDialog extends StatefulWidget {
  final Alat? alat;
  final List<Kategori> kategoriList;

  const AlatFormDialog({Key? key, this.alat, required this.kategoriList})
    : super(key: key);

  @override
  State<AlatFormDialog> createState() => _AlatFormDialogState();
}

class _AlatFormDialogState extends State<AlatFormDialog> {
  late TextEditingController namaController;
  late TextEditingController stokTotalController;
  late TextEditingController stokTersediaController;
  String? selectedKategori;
  String kondisi = 'baik';
  bool isActive = true;
  String? fotoUrl;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.alat?.nama ?? '');
    stokTotalController = TextEditingController(
      text: widget.alat?.stokTotal.toString() ?? '',
    );
    stokTersediaController = TextEditingController(
      text: widget.alat?.stokTersedia.toString() ?? '',
    );
    selectedKategori = widget.alat?.kategoriId;
    kondisi = widget.alat?.kondisi ?? 'baik';
    isActive = widget.alat?.isActive ?? true;
    fotoUrl = widget.alat?.fotoUrl;
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
    final isEdit = widget.alat != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
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
                  child: const Icon(
                    Icons.build_circle,
                    color: Color(0xFFFF8C42),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    isEdit ? 'Edit Alat' : 'Tambah Alat',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preview Foto
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Implementasi upload foto (image_picker)
                          setState(
                            () => fotoUrl = 'assets/images/uploaded.png',
                          );
                          _showSnackBar('Foto berhasil diupload', false);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: fotoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(
                                        fotoUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 60,
                                                    color: Colors.grey[400],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'Foto Alat',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.6,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFFF8C42,
                                        ).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add_photo_alternate,
                                        size: 50,
                                        color: Color(0xFFFF8C42),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Klik untuk upload foto',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFF8C42),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'PNG, JPG, JPEG (Max 5MB)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Kategori
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        prefixIcon: const Icon(Icons.category_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF8C42),
                            width: 2,
                          ),
                        ),
                      ),
                      value: selectedKategori,
                      items: widget.kategoriList
                          .where((k) => k.isActive)
                          .map(
                            (k) => DropdownMenuItem(
                              value: k.id,
                              child: Text(k.nama),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedKategori = value),
                    ),
                    const SizedBox(height: 16),

                    // Nama Alat
                    TextField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Alat',
                        hintText: 'Masukkan nama alat',
                        prefixIcon: const Icon(Icons.build_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF8C42),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stok Total dan Tersedia
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: stokTotalController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Stok Total',
                              prefixIcon: const Icon(
                                Icons.inventory_2_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFF8C42),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: stokTersediaController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Stok Tersedia',
                              prefixIcon: const Icon(Icons.checklist_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFF8C42),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Kondisi
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Kondisi',
                        prefixIcon: const Icon(
                          Icons.health_and_safety_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF8C42),
                            width: 2,
                          ),
                        ),
                      ),
                      value: kondisi,
                      items: const [
                        DropdownMenuItem(value: 'baik', child: Text('Baik')),
                        DropdownMenuItem(value: 'rusak', child: Text('Rusak')),
                      ],
                      onChanged: (value) => setState(() => kondisi = value!),
                    ),
                    const SizedBox(height: 16),

                    // Status Aktif
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SwitchListTile(
                        title: const Text(
                          'Status Aktif',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          isActive ? 'Alat dapat dipinjam' : 'Alat tidak aktif',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        value: isActive,
                        activeColor: const Color(0xFFFF8C42),
                        onChanged: (value) => setState(() => isActive = value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                    child: const Text('Batal', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _simpan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C42),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      isEdit ? 'Update' : 'Simpan',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

  void _simpan() {
    // Validasi input
    if (selectedKategori == null) {
      _showSnackBar('Kategori harus dipilih', true);
      return;
    }

    if (namaController.text.isEmpty) {
      _showSnackBar('Nama alat harus diisi', true);
      return;
    }

    if (stokTotalController.text.isEmpty ||
        stokTersediaController.text.isEmpty) {
      _showSnackBar('Stok harus diisi', true);
      return;
    }

    int stokTotal = int.tryParse(stokTotalController.text) ?? -1;
    int stokTersedia = int.tryParse(stokTersediaController.text) ?? -1;

    if (stokTotal < 0 || stokTersedia < 0) {
      _showSnackBar('Stok tidak boleh negatif', true);
      return;
    }

    if (stokTersedia > stokTotal) {
      _showSnackBar('Stok tersedia tidak boleh lebih dari stok total', true);
      return;
    }

    // TODO: Simpan/Update ke database
    final alatData = {
      'id': widget.alat?.id ?? DateTime.now().toString(),
      'kategori_id': selectedKategori,
      'nama_alat': namaController.text,
      'stok_total': stokTotal,
      'stok_tersedia': stokTersedia,
      'kondisi': kondisi,
      'is_active': isActive,
      'foto_url': fotoUrl,
    };

    Navigator.pop(context, alatData);
    _showSnackBar(
      'Alat berhasil ${widget.alat != null ? "diupdate" : "ditambahkan"}',
      false,
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    stokTotalController.dispose();
    stokTersediaController.dispose();
    super.dispose();
  }
}
