import '../models/user.dart';
import '../services/database_service.dart';

class UserController {
  final DatabaseService _db = DatabaseService();

  /// Stream users dari database, realtime
  Stream<List<User>> streamUsers() {
    return _db.streamUsers().map(
      (list) => list.map((e) => User.fromJson(e)).toList(),
    );
  }

  /// Insert user baru ke database
  Future<void> insertUser(Map<String, dynamic> data) async {
    await _db.insertUser(data);
  }

  /// Update user
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _db.updateUser(id, data);
  }

  /// Soft delete user
  Future<void> deleteUser(String id) async {
    await _db.deleteUser(id);
  }

  /// Get user by id
  Future<User?> getUserById(String id) async {
    final res = await _db.getUserById(id);
    if (res == null) return null;
    return User.fromJson(res);
  }
}
