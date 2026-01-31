import 'package:apk_peminjaman/models/denda.dart';

class Pengembalian {
  final String id;
  final String peminjamanId;
  final String petugasId;
  final DateTime tanggalKembali;
  final String kondisi; // baik, rusak, hilang
  final bool terlambat;
  final bool isActive;
  final DateTime createdAt;

  // joined
  final String? namaPetugas;
  final Denda? denda;

  Pengembalian({
    required this.id,
    required this.peminjamanId,
    required this.petugasId,
    required this.tanggalKembali,
    required this.kondisi,
    required this.terlambat,
    required this.isActive,
    required this.createdAt,
    this.namaPetugas,
    this.denda,
  });

  factory Pengembalian.fromJson(Map<String, dynamic> json) {
    return Pengembalian(
      id: json['id'],
      peminjamanId: json['peminjaman_id'],
      petugasId: json['petugas_id'],
      tanggalKembali: DateTime.parse(json['tanggal_kembali']),
      kondisi: json['kondisi'],
      terlambat: json['terlambat'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      namaPetugas: json['petugas']?['nama_lengkap'],
      denda: json['denda'] != null ? Denda.fromJson(json['denda']) : null,
    );
  }
}