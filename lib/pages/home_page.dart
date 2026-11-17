import 'package:flutter/material.dart';
import '../models/game.dart';
import '../services/api_service.dart';
import '../widgets/game_tile.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Game>> _futureGames;

  String _query = '';
  String _selectedGenre = 'Semua';

  @override
  void initState() {
    super.initState();
    _futureGames = _apiService.fetchGames();
  }

  void _retry() {
    setState(() {
      _futureGames = _apiService.fetchGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Games',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Game>>(
        future: _futureGames,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Gagal memuat data game'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final games = snapshot.data!;

          // Daftar genre diambil dari datanya sendiri (toSet = buang duplikat)
          final genres = [
            'Semua',
            ...(games.map((g) => g.genre).toSet().toList()..sort()),
          ];

          // Terapkan search + filter genre sekaligus
          final filtered = games.where((g) {
            final matchQuery =
                g.title.toLowerCase().contains(_query.toLowerCase());
            final matchGenre =
                _selectedGenre == 'Semua' || g.genre == _selectedGenre;
            return matchQuery && matchGenre;
          }).toList();

          return Column(
            children: [
              // Kolom search
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Cari game...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),

              // Chip genre (geser horizontal)
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  itemCount: genres.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final genre = genres[index];
                    return ChoiceChip(
                      label: Text(genre),
                      selected: _selectedGenre == genre,
                      onSelected: (_) {
                        setState(() {
                          _selectedGenre = genre;
                        });
                      },
                    );
                  },
                ),
              ),

              // List hasil
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('Game tidak ditemukan',
                            style: TextStyle(color: Colors.grey)),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final game = filtered[index];
                          return GameTile(
                            game: game,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPage(gameId: game.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}