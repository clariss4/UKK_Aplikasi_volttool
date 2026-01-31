class LogAktivitas {
  final String id;
  final String userId;
  final String namaUser;
  final String aktivitas;
  final DateTime waktu;

  LogAktivitas({
    required this.id,
    required this.userId,
    required this.namaUser,
    required this.aktivitas,
    required this.waktu,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'aktivitas': aktivitas,
      'waktu': waktu.toIso8601String(),
    };
  }

  factory LogAktivitas.fromJson(Map<String, dynamic> json) {
    return LogAktivitas(
      id: json['id'],
      userId: json['user_id'],
      namaUser: json['nama_user'] ?? 'Unknown User',
      aktivitas: json['aktivitas'],
      waktu: DateTime.parse(json['waktu']),
    );
  }

  String getWaktuFormatted() {
    final now = DateTime.now();
    final difference = now.difference(waktu);

    if (difference.inMinutes < 1) return 'Baru saja';
    if (difference.inMinutes < 60) return '${difference.inMinutes} menit yang lalu';
    if (difference.inHours < 24) return '${difference.inHours} jam yang lalu';
    if (difference.inDays < 7) return '${difference.inDays} hari yang lalu';

    return '${waktu.day}/${waktu.month}/${waktu.year} ${waktu.hour.toString().padLeft(2,'0')}:${waktu.minute.toString().padLeft(2,'0')}';
  }
}
