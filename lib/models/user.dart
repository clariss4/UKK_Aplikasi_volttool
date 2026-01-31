class User {
  final String id;
  final String username;
  final String namaLengkap;
  final String role;
  final bool isActive;

  User({
    required this.id,
    required this.username,
    required this.namaLengkap,
    required this.role,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      namaLengkap: json['nama_lengkap'],
      role: json['role'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson({String? password}) {
    final data = {
      'id': id,
      'username': username,
      'nama_lengkap': namaLengkap,
      'role': role,
      'is_active': isActive,
    };
    if (password != null) data['password'] = password; // plaintext sesuai Supabase
    return data;
  }
}
