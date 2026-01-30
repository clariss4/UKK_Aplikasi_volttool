import 'package:apk_peminjaman/models/kategori.dart';
import 'package:apk_peminjaman/services/database_service.dart';
import 'package:flutter/material.dart';

class KategoriController extends ChangeNotifier {
  final DatabaseService _service = DatabaseService();
  List<Kategori> kategoriList = [];

  Future<void> loadKategori() async {
    final res = await _service.getKategori();
    kategoriList = res.map((e) => Kategori.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> simpanKategori(Kategori kategori) async {
    if (kategori.id == null) {
      await _service.insertKategori(kategori.toMap());
    } else {
      await _service.updateKategori(kategori.id!, kategori.toMap());
    }
    await loadKategori();
  }
}
