// ==================== FILE: lib/models/alat.dart ====================

class Alat {
  final String? id; // ⬅️ nullable (INSERT aman)
  final String kategoriId;
  final String nama;
  final int stokTotal;
  final int stokTersedia;
  final String kondisi;
  final bool isActive;
  final String? fotoUrl;

  Alat({
    this.id,
    required this.kategoriId,
    required this.nama,
    required this.stokTotal,
    required this.stokTersedia,
    required this.kondisi,
    required this.isActive,
    this.fotoUrl,
  });

  /* ================= MAP → DB ================= */
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // ⬅️ update saja
      'kategori_id': kategoriId,
      'nama_alat': nama,
      'stok_total': stokTotal,
      'stok_tersedia': stokTersedia,
      'kondisi': kondisi,
      'is_active': isActive,
      'foto_url': fotoUrl,
    };
  }

  /* ================= DB → MODEL ================= */
  factory Alat.fromMap(Map<String, dynamic> map) {
    return Alat(
      id: map['id'],
      kategoriId: map['kategori_id'],
      nama: map['nama_alat'],
      stokTotal: map['stok_total'],
      stokTersedia: map['stok_tersedia'],
      kondisi: map['kondisi'],
      isActive: map['is_active'] ?? true,
      fotoUrl: map['foto_url'],
    );
  }
}
