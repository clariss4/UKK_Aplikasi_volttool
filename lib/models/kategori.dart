// ==================== FILE: lib/models/kategori.dart ====================

class Kategori {
  final String? id; // ⬅️ nullable (aman untuk insert)
  final String nama;
  final bool isActive;

  Kategori({
    this.id,
    required this.nama,
    required this.isActive,
  });

  /* ================= MAP → DB ================= */
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // ⬅️ hanya untuk update
      'nama_kategori': nama,
      'is_active': isActive,
    };
  }

  /* ================= DB → MODEL ================= */
  factory Kategori.fromMap(Map<String, dynamic> map) {
    return Kategori(
      id: map['id'],
      nama: map['nama_kategori'],
      isActive: map['is_active'] ?? true,
    );
  }
}
