import 'package:flutter/material.dart';

// ==================== FILE: lib/models/alat.dart ====================
class Alat {
  final String id;
  final String kategoriId;
  final String nama;
  final int stokTotal;
  final int stokTersedia;
  final String kondisi;
  final bool isActive;
  final String? fotoUrl;

  Alat({
    required this.id,
    required this.kategoriId,
    required this.nama,
    required this.stokTotal,
    required this.stokTersedia,
    required this.kondisi,
    required this.isActive,
    this.fotoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori_id': kategoriId,
      'nama_alat': nama,
      'stok_total': stokTotal,
      'stok_tersedia': stokTersedia,
      'kondisi': kondisi,
      'is_active': isActive,
      'foto_url': fotoUrl,
    };
  }

  factory Alat.fromJson(Map<String, dynamic> json) {
    return Alat(
      id: json['id'],
      kategoriId: json['kategori_id'],
      nama: json['nama_alat'],
      stokTotal: json['stok_total'],
      stokTersedia: json['stok_tersedia'],
      kondisi: json['kondisi'],
      isActive: json['is_active'] ?? true,
      fotoUrl: json['foto_url'],
    );
  }
}