import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/game.dart';

class LibraryService {
  static const String boxName = 'library';

  // Box sudah dibuka di main.dart, di sini tinggal diambil
  Box get _box => Hive.box(boxName);
  
 ValueListenable<Box> get listenable => _box.listenable();

  // Ambil semua game di library
  List<Game> getGames() {
    return _box.values.map((item) => Game.fromMap(item)).toList();
  }

  // Cek apakah game sudah dimiliki (menentukan tampilan tombol di Detail Page)
  bool isOwned(int id) {
    return _box.containsKey(id);
  }

  // Tambah game ke library
  Future<void> addGame(Game game) async {
    await _box.put(game.id, game.toMap());
  }

  // Hapus game dari library
  Future<void> removeGame(int id) async {
    await _box.delete(id);
  }

  // Jumlah game (dipakai di Profile Page)
  int get count => _box.length;
}