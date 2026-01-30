// ==================== FILE: lib/models/alat.dart ====================

class Alat {
  final String id;
  final String kategoriId;
  final String nama;
  final String? fotoUrl;
  final int stokTotal;
  final int stokTersedia;
  final String kondisi;
  final bool isActive;
  final DateTime? createdAt;

  Alat({
    required this.id,
    required this.kategoriId,
    required this.nama,
    this.fotoUrl,
    required this.stokTotal,
    required this.stokTersedia,
    this.kondisi = 'baik',
    this.isActive = true,
    this.createdAt,
  });

  /* ================= JSON → MODEL ================= */
  factory Alat.fromJson(Map<String, dynamic> json) {
    return Alat(
      id: json['id'] as String,
      kategoriId: json['kategori_id'] as String,
      nama: json['nama_alat'] as String,
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

  /* ================= MODEL → MAP (untuk dialog) ================= */
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kategori_id': kategoriId,
      'nama_alat': nama,
      'foto_url': fotoUrl,
      'stok_total': stokTotal,
      'stok_tersedia': stokTersedia,
      'kondisi': kondisi,
      'is_active': isActive,
    };
  }
}