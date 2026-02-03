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
    "peminjam": "Clarissa Aurelia Qurnia Putri",
    "deskripsiAlat": "3 alat · Tang tangan, multimeter 1+",
    "tanggalPinjam": "12/01/2026",
    "batasPengembalian": "13/01/2026",
    "status": "Menunggu",
  },
  {
    "peminjam": "Andi Wijaya",
    "deskripsiAlat": "1 alat · Multimeter",
    "tanggalPinjam": "25/01/2026",
    "batasPengembalian": "26/01/2026",
    "status": "Meminjam",
  },
  {
    "peminjam": "Budi Santoso",
    "deskripsiAlat": "2 alat · Obeng set, tang",
    "tanggalPinjam": "25/01/2026",
    "batasPengembalian": "27/01/2026",
    "status": "Meminjam",
  },
  {
    "peminjam": "Citra Lestari",
    "deskripsiAlat": "1 alat · Tang listrik",
    "tanggalPinjam": "23/01/2026",
    "batasPengembalian": "24/01/2026",
    "status": "Dikembalikan",
  },
  {
    "peminjam": "Dina Prameswari",
    "deskripsiAlat": "1 alat · Isolasi listrik",
    "tanggalPinjam": "22/01/2026",
    "batasPengembalian": "23/01/2026",
    "status": "Terlambat",
  },
];
