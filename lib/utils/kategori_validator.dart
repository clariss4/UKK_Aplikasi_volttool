class KategoriValidator {
  static String? validate(String nama) {
    if (nama.isEmpty) return 'Nama kategori wajib diisi';
    return null;
  }
}
