import 'dart:async';

import 'package:bloc/bloc.dart';
import '../models/kategori.dart';
import '../services/database_service.dart';

class KategoriCubit extends Cubit<List<Kategori>> {
  final DatabaseService _db;
  late final Stream<List<Kategori>> _kategoriStream;
  late final StreamSubscription<List<Kategori>> _sub;

  KategoriCubit(this._db) : super([]) {
    _kategoriStream = _db.streamKategoriAll();
    _sub = _kategoriStream.listen(
      (data) => emit(data),
      onError: (e) => print('Stream Kategori Error: $e'),
    );
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
