// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

/// ================= DUMMY LOG AKTIVITAS HARI INI =================
final List<Map<String, String>> DASHBOARD_LOGS = [
  {
    "nama": "Petugas_1",
    "desc": "Telah mengkonfirmasi peminjaman alat ...",
    "role": "Petugas",
    "time": "09:30",
    "status": "",
  },
  {
    "nama": "Clarissa Aurelia QP",
    "desc": "Mengajukan peminjaman alat ... 2 alat",
    "role": "Peminjam",
    "time": "09:30",
    "status": "Menunggu",
  },
  {
    "nama": "Clarissa Aurelia QP",
    "desc": "Pengembalian alat ... 1 alat",
    "role": "Peminjam",
    "time": "09:30",
    "status": "Dikembalikan",
  },
  {
    "nama": "Clarissa Aurelia QP",
    "desc": "Mengajukan peminjaman alat ... 3 alat",
    "role": "Peminjam",
    "time": "10:00",
    "status": "Menunggu",
  },
  {
    "nama": "Andi Setiawan",
    "desc": "Mengajukan peminjaman alat ... 1 alat",
    "role": "Peminjam",
    "time": "10:15",
    "status": "Dikembalikan",
  },
  {
    "nama": "Rina Safitri",
    "desc": "Pengembalian alat ... 2 alat",
    "role": "Peminjam",
    "time": "10:45",
    "status": "Terlambat",
  },
  {
    "nama": "Budi Santoso",
    "desc": "Mengajukan peminjaman alat ... 1 alat",
    "role": "Peminjam",
    "time": "11:00",
    "status": "Dipinjam",
  },
];

/// ================= DUMMY PEMINJAMAN HARI INI =================
final List<Map<String, String>> PEMINJAMAN_HARI_INI = [
  {
    "namaAlat": "Multimeter",
    "peminjam": "Andi",
    "tanggalPinjam": "2026-01-25",
    "status": "Dipinjam",
  },
  {
    "namaAlat": "Obeng Set",
    "peminjam": "Budi",
    "tanggalPinjam": "2026-01-25",
    "status": "Dipinjam",
  },
  {
    "namaAlat": "Tang Listrik",
    "peminjam": "Citra",
    "tanggalPinjam": "2026-01-25",
    "status": "Kembali",
  },
  {
    "namaAlat": "Isolasi Listrik",
    "peminjam": "Dina",
    "tanggalPinjam": "2026-01-25",
    "status": "Dipinjam",
  },
];
