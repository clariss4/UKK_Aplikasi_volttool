class Peminjaman {
  final String id;
  final String peminjamId;
  final String namaPeminjam;
  final String username;
  final String? petugas;
  final DateTime tanggalPinjam;
  final DateTime batasKembali;
  final DateTime? tanggalKembali;
  final String status;
  final List<AlatPinjam> alatDipinjam;
  final String kondisi;
  final Denda? denda;
  final bool isActive;

  Peminjaman({
    required this.id,
    required this.peminjamId,
    required this.namaPeminjam,
    required this.username,
    this.petugas,
    required this.tanggalPinjam,
    required this.batasKembali,
    this.tanggalKembali,
    required this.status,
    required this.alatDipinjam,
    required this.kondisi,
    this.denda,
    this.isActive = true,
  });
}

class AlatPinjam {
  final String namaAlat;
  final int jumlah;
  final String kategori;

  AlatPinjam({
    required this.namaAlat, 
    required this.jumlah,
    this.kategori = 'Alat Ukur',
  });
}

class Denda {
  final String jenis;
  final int jumlah;

  Denda({required this.jenis, required this.jumlah});
}
