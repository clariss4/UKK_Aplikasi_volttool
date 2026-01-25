class User {
  final String id;
  final String namaLengkap;
  final String username;
  final String password;
  final String role;
  final bool isActive;

  User({
    required this.id,
    required this.namaLengkap,
    required this.username,
    required this.password,
    required this.role,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_lengkap': namaLengkap,
      'username': username,
      'password': password,
      'role': role,
      'is_active': isActive,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      namaLengkap: json['nama_lengkap'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      isActive: json['is_active'] ?? true,
    );
  }
}