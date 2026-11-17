import 'package:flutter/material.dart';
import '../models/game.dart';

class GameTile extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;
  final Widget? trailing; // kalau null, tampil panah

  const GameTile({
    super.key,
    required this.game,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // i. Thumbnail
            Image.network(
              game.thumbnail,
              width: 100,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 80,
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ii. Nama
                  Text(
                    game.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  // iii. Genre
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(game.genre,
                        style: const TextStyle(fontSize: 11)),
                  ),
                  const SizedBox(height: 4),
                  // iv. Platform
                  Text(
                    game.platform,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}