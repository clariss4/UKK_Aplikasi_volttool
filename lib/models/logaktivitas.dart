class LogAktivitas {
  final String id;
  final String userId;
  final String namaUser; // dari relasi users.nama_lengkap
  final String aktivitas;
  final DateTime waktu;

  LogAktivitas({
    required this.id,
    required this.userId,
    required this.namaUser,
    required this.aktivitas,
    required this.waktu,
  });

  factory LogAktivitas.fromJson(Map<String, dynamic> json) {
    // relasi users bisa null kalau select tidak join
    final user = json['users'];

    return LogAktivitas(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      namaUser: user != null ? (user['nama_lengkap'] ?? '-') : '-',
      aktivitas: json['aktivitas'] ?? '',
      waktu: DateTime.parse(json['waktu']),
    );
  }
}
