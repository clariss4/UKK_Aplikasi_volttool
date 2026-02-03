class Kategori {
  final String id;
  final String namaKategori;
  final bool isActive;
  final DateTime? createdAt;

  Kategori({
    required this.id,
    required this.namaKategori,
    this.isActive = true,
    this.createdAt,
  });

  /* ================= JSON → MODEL ================= */
  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'] as String,
      namaKategori: json['nama_kategori'] as String,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  /* ================= MAP UNTUK INSERT / UPDATE ================= */
  Map<String, dynamic> toInsertMap() {
    return {
      'nama_kategori': namaKategori,
      'is_active': isActive,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'nama_kategori': namaKategori,
      'is_active': isActive,
    };
  }
}