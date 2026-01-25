import 'models/user.dart';
import 'models/kategori.dart';
import 'models/alat.dart';
import 'models/log_aktivitas.dart';

class DummyData {
  // ==================== USER ====================
  static final List<User> userList = [
    // Petugas
    User(
      id: '1',
      namaLengkap: 'Rudi Santoso',
      username: 'rudi@volttool.com',
      password: 'password123',
      role: 'petugas',
      isActive: true,
    ),
    User(
      id: '2',
      namaLengkap: 'Sari Lestari',
      username: 'sari@volttool.com',
      password: 'password123',
      role: 'petugas',
      isActive: true,
    ),
    // Peminjam
    User(
      id: '3',
      namaLengkap: 'Ahmad Fauzi',
      username: 'ahmad@volttool.com',
      password: 'password123',
      role: 'peminjam',
      isActive: true,
    ),
    User(
      id: '4',
      namaLengkap: 'Dewi Anggraeni',
      username: 'dewi@volttool.com',
      password: 'password123',
      role: 'peminjam',
      isActive: false,
    ),
  ];

  // ==================== KATEGORI ====================
  static final List<Kategori> kategoriList = [
    Kategori(id: '1', nama: 'Alat Ukur', isActive: true),
    Kategori(id: '2', nama: 'Alat Solder', isActive: true),
    Kategori(id: '3', nama: 'Alat Potong', isActive: false),
  ];

  // ==================== ALAT ====================
  static final List<Alat> alatList = [
    Alat(
      id: '1',
      kategoriId: '1',
      nama: 'Tang Tangan',
      stokTotal: 34,
      stokTersedia: 24,
      kondisi: 'baik',
      isActive: true,
      fotoUrl: 'assets/images/tang.png',
    ),
    Alat(
      id: '2',
      kategoriId: '1',
      nama: 'Meteran Digital',
      stokTotal: 20,
      stokTersedia: 15,
      kondisi: 'baik',
      isActive: false,
      fotoUrl: 'assets/images/meteran.png',
    ),
  ];

  /// ==================== LOG AKTIVITAS ====================
  static final List<LogAktivitas> logList = [
    LogAktivitas(
      id: '1',
      userId: '1',
      namaUser: 'Admin Sistem',
      aktivitas: 'Login ke sistem',
      waktu: DateTime.now().subtract(const Duration(minutes: 5)),
      kategori: 'Login',
    ),
    LogAktivitas(
      id: '2',
      userId: '2',
      namaUser: 'Petugas Lab',
      aktivitas: 'Menambahkan alat baru "Tang Potong"',
      waktu: DateTime.now().subtract(const Duration(minutes: 15)),
      kategori: 'Alat',
    ),
    LogAktivitas(
      id: '3',
      userId: '3',
      namaUser: 'Ahmad Fauzi',
      aktivitas: 'Meminjam 2 unit Multimeter Digital',
      waktu: DateTime.now().subtract(const Duration(hours: 1)),
      kategori: 'Peminjaman',
    ),
    LogAktivitas(
      id: '4',
      userId: '1',
      namaUser: 'Admin Sistem',
      aktivitas: 'Mengembalikan alat "Tang Tangan"',
      waktu: DateTime.now().subtract(const Duration(hours: 2)),
      kategori: 'Pengembalian',
    ),
    LogAktivitas(
      id: '5',
      userId: '2',
      namaUser: 'Petugas Lab',
      aktivitas: 'Menambahkan kategori "Alat Las"',
      waktu: DateTime.now().subtract(const Duration(days: 1)),
      kategori: 'Kategori',
    ),
  ];
}
