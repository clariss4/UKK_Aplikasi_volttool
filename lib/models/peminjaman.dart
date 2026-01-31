import 'package:apk_peminjaman/models/peminjaman_detail.dart';

class Peminjaman {
  final String id;
  final String peminjamId;
  final String? petugasId;
  final DateTime tanggalPinjam;
  final DateTime batasPengembalian;
  final String status; // menunggu, disetujui, ditolak, dipinjam, dikembalikan
  final DateTime createdAt;

  // Data joined dari users & detail
  final String namaPeminjam;
  final String usernamePeminjam;
  final String? namaPetugas;
  final List<PeminjamanDetail> detailAlat;

  Peminjaman({
    required this.id,
    required this.peminjamId,
    this.petugasId,
    required this.tanggalPinjam,
    required this.batasPengembalian,
    required this.status,
    required this.createdAt,
    required this.namaPeminjam,
    required this.usernamePeminjam,
    this.namaPetugas,
    this.detailAlat = const [],
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: json['id'],
      peminjamId: json['peminjam_id'],
      petugasId: json['petugas_id'],
      tanggalPinjam: DateTime.parse(json['tanggal_pinjam']),
      batasPengembalian: DateTime.parse(json['batas_pengembalian']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      namaPeminjam: json['peminjam']?['nama_lengkap'] ?? 'Unknown',
      usernamePeminjam: json['peminjam']?['username'] ?? '-',
      namaPetugas: json['petugas']?['nama_lengkap'],
      detailAlat: (json['peminjaman_detail'] as List<dynamic>? ?? [])
          .map((e) => PeminjamanDetail.fromJson(e))
          .toList(),
    );
  }

}