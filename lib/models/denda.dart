import 'package:uuid/uuid.dart';

class Denda {
  final String id;
  final String pengembalianId;
  final String jenisDenda;
  final int jumlahDenda;

  Denda({
    String? id,
    required this.pengembalianId,
    required this.jenisDenda,
    required this.jumlahDenda,
  }) : id = id ?? Uuid().v4();
}
