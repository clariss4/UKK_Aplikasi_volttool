class User {
  final String id;
  final String username;
  final String namaLengkap;
  final String role;
  final bool isActive;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.username,
    required this.namaLengkap,
    required this.role,
    this.isActive = true,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      namaLengkap: json['nama_lengkap'] as String,
      role: json['role'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// PERBAIKAN: Tidak include ID, biarkan database auto-generate
  Map<String, dynamic> toJson({String? password}) {
    final data = <String, dynamic>{
      'username': username,
      'nama_lengkap': namaLengkap,
      'role': role,
      'is_active': isActive,
    };
    
    // Hanya tambahkan password jika diberikan (untuk insert/update)
    if (password != null && password.isNotEmpty) {
      data['password'] = password;
    }
    
    return data;
  }

  /// Copy with method untuk update immutable object
  User copyWith({
    String? id,
    String? username,
    String? namaLengkap,
    String? role,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}