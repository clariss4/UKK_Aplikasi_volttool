import 'alat.dart';

class BorrowCartItem {
  final Alat alat;
  int jumlah;

  BorrowCartItem({
    required this.alat,
    this.jumlah = 1,
  });
}
