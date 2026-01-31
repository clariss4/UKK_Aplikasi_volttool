class Denda {
  final String id;
  final String pengembalianId;
  final String jenisDenda; // terlambat, rusak, hilang
  final int jumlahDenda;

  Denda({
    required this.id,
    required this.pengembalianId,
    required this.jenisDenda,
    required this.jumlahDenda,
  });

  factory Denda.fromJson(Map<String, dynamic> json) {
    return Denda(
      id: json['id'],
      pengembalianId: json['pengembalian_id'],
      jenisDenda: json['jenis_denda'],
      jumlahDenda: json['jumlah_denda'],
    );
  }

  String get display {
    return '$jenisDenda: Rp ${jumlahDenda.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}