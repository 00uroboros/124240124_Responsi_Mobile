import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/game.dart';
import '../services/library_service.dart';
import '../widgets/game_tile.dart';
import 'detail_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final LibraryService _libraryService = LibraryService();

  Future<void> _confirmDelete(Game game) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus dari library?'),
        content: Text('${game.title} akan dihapus dari library kamu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _libraryService.removeGame(game.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Anda',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      // Dibangun ulang otomatis setiap isi box Hive berubah (tambah/hapus)
      body: ValueListenableBuilder<Box>(
        valueListenable: _libraryService.listenable,
        builder: (context, box, _) {
          final games = _libraryService.getGames();

          if (games.isEmpty) {
            return const Center(
              child: Text(
                'Library masih kosong.\nTekan "Get" pada game untuk menambahkan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return GameTile(
                game: game,
                // b. Klik -> ke Detail Page game tersebut
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(gameId: game.id),
                    ),
                  );
                },
                // a-ii. Tombol delete
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(game),
                ),
              );
            },
          );
        },
      ),
    );
  }
}