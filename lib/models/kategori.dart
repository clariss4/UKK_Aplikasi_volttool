import 'package:flutter/material.dart';
class Kategori {
  final String id;
  final String nama;
  final bool isActive;

  Kategori({
    required this.id,
    required this.nama,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kategori': nama,
      'is_active': isActive,
    };
  }

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      nama: json['nama_kategori'],
      isActive: json['is_active'] ?? true,
    );
  }
}

