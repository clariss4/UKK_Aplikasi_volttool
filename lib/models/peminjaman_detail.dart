class PeminjamanDetail {
  final String id;
  final String alatId;
  final int jumlah;

  // joined
  final String? namaAlat;

  PeminjamanDetail({
    required this.id,
    required this.alatId,
    required this.jumlah,
    this.namaAlat,
  });

  factory PeminjamanDetail.fromJson(Map<String, dynamic> json) {
    return PeminjamanDetail(
      id: json['id'],
      alatId: json['alat_id'],
      jumlah: json['jumlah'],
      namaAlat: json['alat']?['nama_alat'],
    );
  }
}