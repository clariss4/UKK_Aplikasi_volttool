import 'dart:async';
import 'package:bloc/bloc.dart';
import '../models/alat.dart';
import '../services/database_service.dart';

class AlatCubit extends Cubit<List<Alat>> {
  final DatabaseService _db;
  late final Stream<List<Alat>> _alatStream;
  late final StreamSubscription<List<Alat>> _sub;

  AlatCubit(this._db) : super([]) {
    _alatStream = _db.streamAlatAll();
    _sub = _alatStream.listen(
      (data) => emit(data),
      onError: (e) => print('Stream Alat Error: $e'),
    );
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
