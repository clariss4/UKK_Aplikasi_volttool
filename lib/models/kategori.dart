// ==================== FILE: lib/models/kategori.dart ====================

class Kategori {
  final String id;
  final String nama;
  final bool isActive;
  final DateTime? createdAt;

  Kategori({
    required this.id,
    required this.nama,
    this.isActive = true,
    this.createdAt,
  });

  /* ================= JSON → MODEL ================= */
  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'] as String,
      nama: json['nama_kategori'] as String,
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
      'nama_kategori': nama,
      'is_active': isActive,
    };
  }
}