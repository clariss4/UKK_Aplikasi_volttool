import 'package:flutter/material.dart';
import '../models/alat.dart';
import '../services/database_service.dart';

class AlatController extends ChangeNotifier {
  final DatabaseService _service = DatabaseService();
  List<Alat> alatList = [];

  Future<void> loadAlat() async {
    final res = await _service.getAlat();
    alatList = res.map((e) => Alat.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> simpanAlat(Alat alat) async {
    if (alat.id == null) {
      await _service.insertAlat(alat.toMap());
    } else {
      await _service.updateAlat(alat.id!, alat.toMap());
    }
    await loadAlat();
  }
}
