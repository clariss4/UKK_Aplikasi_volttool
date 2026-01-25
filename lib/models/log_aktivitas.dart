class LogAktivitas {
  final String id;
  final String userId;
  final String namaUser;
  final String aktivitas;
  final DateTime waktu;
  final String kategori; // <-- baru

  LogAktivitas({
    required this.id,
    required this.userId,
    required this.namaUser,
    required this.aktivitas,
    required this.waktu,
    required this.kategori, // <-- baru
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'aktivitas': aktivitas,
      'waktu': waktu.toIso8601String(),
      'kategori': kategori, // <-- baru
    };
  }

  factory LogAktivitas.fromJson(Map<String, dynamic> json) {
    return LogAktivitas(
      id: json['id'],
      userId: json['user_id'],
      namaUser: json['nama_user'] ?? 'Unknown User',
      aktivitas: json['aktivitas'],
      waktu: DateTime.parse(json['waktu']),
      kategori: json['kategori'] ?? 'Lainnya', // <-- baru
    );
  }

  String getWaktuFormatted() {
    final now = DateTime.now();
    final difference = now.difference(waktu);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${waktu.day}/${waktu.month}/${waktu.year} ${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}';
    }
  }
}
