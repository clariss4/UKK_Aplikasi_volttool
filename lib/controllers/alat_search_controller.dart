import 'package:flutter/material.dart';
import '../models/alat.dart';

class AlatSearchController extends ChangeNotifier {
  String _keyword = '';

  void setKeyword(String value) {
    _keyword = value.toLowerCase();
    notifyListeners();
  }

  List<Alat> filter(List<Alat> alat) {
    if (_keyword.isEmpty) return alat;

    return alat
        .where((a) =>
            a.namaAlat.toLowerCase().contains(_keyword))
        .toList();
  }
}
