import 'package:uuid/uuid.dart';

class PeminjamanDetail {
  final String id;
  final String peminjamanId;
  final String alatId;
  final int jumlah;

  PeminjamanDetail({
    String? id,
    required this.peminjamanId,
    required this.alatId,
    required this.jumlah,
  }) : id = id ?? const Uuid().v4();
}
