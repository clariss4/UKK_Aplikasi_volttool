import 'package:flutter/material.dart';

class BorrowItem {
  final String id;
  final String nama;
  int qty;
  final int stok;

  BorrowItem({
    required this.id,
    required this.nama,
    required this.qty,
    required this.stok,
  });
}

class BorrowCartController extends ChangeNotifier {
  final List<BorrowItem> _items = [];

  List<BorrowItem> get items => _items;

  int get totalQty =>
      _items.fold(0, (sum, item) => sum + item.qty);

  int getQty(String id) {
  final index = _items.indexWhere((e) => e.id == id);
  if (index == -1) return 0;
  return _items[index].qty;
}


  void addManual({
    required String id,
    required String nama,
    required int stok,
  }) {
    final index = _items.indexWhere((e) => e.id == id);

    if (index >= 0) {
      if (_items[index].qty < stok) {
        _items[index].qty++;
      }
    } else {
      _items.add(
        BorrowItem(
          id: id,
          nama: nama,
          qty: 1,
          stok: stok,
        ),
      );
    }
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void increase(String id) {
    final item = _items.firstWhere((e) => e.id == id);
    if (item.qty < item.stok) {
      item.qty++;
      notifyListeners();
    }
  }

  void decrease(String id) {
    final item = _items.firstWhere((e) => e.id == id);
    if (item.qty > 1) {
      item.qty--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
