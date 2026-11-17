// Dipakai untuk list (Home & Library)
class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String genre;
  final String platform;

  Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
  });

  // JSON dari API -> objek Game
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      genre: json['genre'],
      platform: json['platform'],
    );
  }

  // Objek Game -> Map, supaya bisa disimpan di Hive
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'genre': genre,
      'platform': platform,
    };
  }

  // Map dari Hive -> objek Game
  factory Game.fromMap(Map map) {
    return Game(
      id: map['id'],
      title: map['title'],
      thumbnail: map['thumbnail'],
      genre: map['genre'],
      platform: map['platform'],
    );
  }
}

// Dipakai untuk Detail Page
class GameDetail {
  final int id;
  final String title;
  final String thumbnail;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;
  final String description;
  final List<String> screenshots;

  GameDetail({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.description,
    required this.screenshots,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    // 'screenshots' di API berupa list objek {id, image}, kita ambil 'image'-nya saja
    final List shots = json['screenshots'] ?? [];
    return GameDetail(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      genre: json['genre'],
      platform: json['platform'],
      publisher: json['publisher'],
      developer: json['developer'],
      releaseDate: json['release_date'],
      description: json['description'],
      screenshots: shots.map<String>((s) => s['image'] as String).toList(),
    );
  }

  // Dipakai saat tombol "Get" ditekan: ubah detail jadi Game ringkas untuk disimpan di library
  Game toGame() {
    return Game(
      id: id,
      title: title,
      thumbnail: thumbnail,
      genre: genre,
      platform: platform,
    );
  }
}