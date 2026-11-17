import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class ApiService {
  static const String _baseUrl = 'https://www.freetogame.com/api';

  // GET /games -> daftar semua game
  Future<List<Game>> fetchGames() async {
    final response = await http.get(Uri.parse('$_baseUrl/games'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Game.fromJson(item)).toList();
    }
    throw Exception('Gagal memuat daftar game (${response.statusCode})');
  }

  // GET /game?id=... -> detail satu game
  Future<GameDetail> fetchGameDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/game?id=$id'));

    if (response.statusCode == 200) {
      return GameDetail.fromJson(jsonDecode(response.body));
    }
    throw Exception('Gagal memuat detail game (${response.statusCode})');
  }
}