class Alat {
  final String id;
  final String kategoriId;
  final String namaAlat;
  final String? fotoUrl;
  final int stokTotal;
  final int stokTersedia;
  final String kondisi;
  final bool isActive;
  final DateTime? createdAt;

  Alat({
    required this.id,
    required this.kategoriId,
    required this.namaAlat,
    this.fotoUrl,
    required this.stokTotal,
    required this.stokTersedia,
    this.kondisi = 'baik',
    this.isActive = true,
    this.createdAt,
  });

  /* ================= JSON → MODEL ==========  ======= */
  factory Alat.fromJson(Map<String, dynamic> json) {
    return Alat(
      id: json['id'] as String,
      kategoriId: json['kategori_id'] as String,
      namaAlat: json['nama_alat'] as String,
      fotoUrl: json['foto_url'],
      stokTotal: json['stok_total'] as int,
      stokTersedia: json['stok_tersedia'] as int,
      kondisi: json['kondisi'] ?? 'baik',
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  /* ================= MAP UNTUK INSERT / UPDATE ================= */
  Map<String, dynamic> toInsertMap() {
    return {
      'kategori_id': kategoriId,
      'nama_alat': namaAlat,
      'stok_total': stokTotal,
      'kondisi': kondisi,
      'is_active': isActive,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'kategori_id': kategoriId,
      'nama_alat': namaAlat,
      'stok_total': stokTotal,
      'kondisi': kondisi,
    };
  }
}
