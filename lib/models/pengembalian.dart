import 'package:uuid/uuid.dart';

class Pengembalian {
  final String id;
  final String peminjamanId;
  final String petugasId;
  final DateTime tanggalKembali;
  final String kondisi;
  final bool terlambat;

  Pengembalian({
    String? id,
    required this.peminjamanId,
    required this.petugasId,
    DateTime? tanggalKembali,
    required this.kondisi,
    this.terlambat = false,
  })  : id = id ?? const Uuid().v4(),
        tanggalKembali = tanggalKembali ?? DateTime.now();
}
