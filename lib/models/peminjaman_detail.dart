class PeminjamanDetail {
  final String id;
  final int jumlah;
  final String namaAlat;

  PeminjamanDetail({
    required this.id,
    required this.jumlah,
    required this.namaAlat,
  });

  factory PeminjamanDetail.fromJson(Map<String, dynamic> json) {
    return PeminjamanDetail(
      id: json['id'],
      jumlah: json['jumlah'],
      namaAlat: json['alat']['nama_alat'],
    );
  }
}
