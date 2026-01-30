class AlatValidator {
  static String? validate({
    required String nama,
    required String stokTotal,
    required String stokTersedia,
    required String? kategoriId,
  }) {
    if (kategoriId == null) return 'Kategori wajib dipilih';
    if (nama.isEmpty) return 'Nama alat wajib diisi';

    final total = int.tryParse(stokTotal);
    final tersedia = int.tryParse(stokTersedia);

    if (total == null || tersedia == null) {
      return 'Stok harus berupa angka';
    }

    if (total < 0 || tersedia < 0) {
      return 'Stok tidak boleh negatif';
    }

    if (tersedia > total) {
      return 'Stok tersedia melebihi stok total';
    }

    return null;
  }
}
