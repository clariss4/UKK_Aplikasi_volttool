import '../models/user.dart';
import '../services/database_service.dart';

class UserController {
  final DatabaseService _db = DatabaseService();

  /// Stream users dengan realtime update
  Stream<List<User>> streamUsers() {
    return _db.streamUsers().map(
      (list) => list.map((json) => User.fromJson(json)).toList(),
    );
  }

  /// Stream users berdasarkan role
  Stream<List<User>> streamUsersByRole(String role) {
    return streamUsers().map(
      (users) =>
          users.where((user) => user.role == role && user.isActive).toList(),
    );
  }

  /// Get single user by ID
  Future<User?> getUserById(String id) async {
    try {
      final json = await _db.getUserById(id);
      if (json == null) return null;
      return User.fromJson(json);
    } catch (e) {
      throw Exception('Gagal mengambil data user: $e');
    }
  }

  /// Insert user baru (realtime update otomatis via stream)
  Future<void> insertUser(Map<String, dynamic> data) async {
    _validateUserData(data, isUpdate: false);
    data.remove('id');
    await _db.insertUser(data);
    // Stream otomatis update UI
  }

  /// Update user (realtime update otomatis via stream)
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    _validateUserData(data, isUpdate: true);
    data.remove('id');
    await _db.updateUser(id, data);
    // Stream otomatis update UI
  }

  /// Soft delete user (realtime update otomatis via stream)
  Future<void> deleteUser(String id) async {
    await _db.deleteUser(id);
    // Stream otomatis update UI
  }

  /// Aktivasi user (realtime update otomatis via stream)
  Future<void> activateUser(String id) async {
    await _db.updateUser(id, {'is_active': true});
    // Stream otomatis update UI
  }

  /// Validasi data user
  void _validateUserData(Map<String, dynamic> data, {required bool isUpdate}) {
    if (!isUpdate || data.containsKey('nama_lengkap')) {
      final namaLengkap = data['nama_lengkap'] as String?;
      if (namaLengkap == null || namaLengkap.trim().isEmpty) {
        throw Exception('Nama lengkap tidak boleh kosong');
      }
      if (namaLengkap.trim().length < 3) {
        throw Exception('Nama lengkap minimal 3 karakter');
      }
    }

    if (!isUpdate || data.containsKey('username')) {
      final username = data['username'] as String?;
      if (username == null || username.trim().isEmpty) {
        throw Exception('Username tidak boleh kosong');
      }
      if (username.trim().length < 4) {
        throw Exception('Username minimal 4 karakter');
      }
      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
        throw Exception('Username hanya boleh huruf, angka, underscore');
      }
      
    }

    if (!isUpdate) {
      final password = data['password'] as String?;
      if (password == null || password.length < 8) {
        throw Exception('Password minimal 8 karakter');
      }
    } else if (data.containsKey('password')) {
      final password = data['password'] as String?;
      if (password == null || password.isEmpty) {
        data.remove('password');
      } else if (password.length < 8) {
        throw Exception('Password minimal 8 karakter');
      }
    }

    if (!isUpdate || data.containsKey('role')) {
      final role = data['role'] as String?;
      const validRoles = ['admin', 'petugas', 'peminjam'];
      if (role == null || !validRoles.contains(role)) {
        throw Exception('Role tidak valid');
      }
    }
  }

  /// Check username
  Future<bool> isUsernameExists(String username, {String? excludeId}) async {
    final users = await streamUsers().first;
    return users.any(
      (u) =>
          u.username.toLowerCase() == username.toLowerCase() &&
          (excludeId == null || u.id != excludeId),
    );
  }

  /// Total user aktif
  Future<int> getTotalActiveUsers() async {
    final users = await streamUsers().first;
    return users.where((u) => u.isActive).length;
  }
}
