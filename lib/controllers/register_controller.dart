// import '../services/database_service.dart';

// class RegisterController {
//   final DatabaseService _db = DatabaseService();

//   Future<String?> register({
//     required String nama,
//     required String username,
//     required String password,
//   }) async {
//     if (nama.isEmpty || username.isEmpty || password.isEmpty) {
//       return 'Semua field wajib diisi';
//     }

//     try {
//       await _db.registerAdmin(
//         namaLengkap: nama,
//         username: username,
//         password: password,
//       );
//       return null; // sukses
//     } catch (e) {
//       return 'Gagal registrasi';
//     }
//   }
// }
