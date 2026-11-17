import 'package:flutter/material.dart';
import '../models/game.dart';
import '../services/api_service.dart';
import '../services/library_service.dart';

class DetailPage extends StatefulWidget {
  final int gameId;

  const DetailPage({super.key, required this.gameId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService _apiService = ApiService();
  final LibraryService _libraryService = LibraryService();

  late Future<GameDetail> _futureDetail;
  late bool _owned;

  @override
  void initState() {
    super.initState();
    _futureDetail = _apiService.fetchGameDetail(widget.gameId);
    _owned = _libraryService.isOwned(widget.gameId);
  }

  void _retry() {
    setState(() {
      _futureDetail = _apiService.fetchGameDetail(widget.gameId);
    });
  }

  Future<void> _getGame(GameDetail detail) async {
    await _libraryService.addGame(detail.toGame());

    setState(() {
      _owned = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${detail.title} ditambahkan ke library')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar otomatis punya tombol back karena halaman ini dibuka lewat Navigator.push
      appBar: AppBar(
        title: const Text('Detail',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<GameDetail>(
        future: _futureDetail,
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
                  const Text('Gagal memuat detail game'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final detail = snapshot.data!;
          return _buildContent(detail);
        },
      ),
    );
  }

  Widget _buildContent(GameDetail detail) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // i. Hero image (paling atas & besar)
          Image.network(
            detail.thumbnail,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 220,
              color: Colors.grey[800],
              child: const Center(child: Icon(Icons.broken_image, size: 48)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ii. Genre & Platform
                Row(
                  children: [
                    _chip(detail.genre),
                    const SizedBox(width: 8),
                    _chip(detail.platform),
                  ],
                ),
                const SizedBox(height: 12),

                // iii. Nama game
                Text(
                  detail.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // iv. Tanggal rilis, publisher, developer
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoItem('Release Date', detail.releaseDate),
                    _infoItem('Publisher', detail.publisher),
                    _infoItem('Developer', detail.developer),
                  ],
                ),
                const SizedBox(height: 16),

                // vii. Tombol Get / In Library
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: _owned
                      ? ElevatedButton.icon(
                          onPressed: null, // null = tombol nonaktif (abu-abu)
                          icon: const Icon(Icons.check),
                          label: const Text('In Library'),
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: Colors.grey[800],
                            disabledForegroundColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: () => _getGame(detail),
                          icon: const Icon(Icons.add),
                          label: const Text('Get'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // v. Screenshots
                const Text('Screenshots',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: detail.screenshots.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          detail.screenshots[index],
                          width: 160,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 160,
                            color: Colors.grey[800],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // vi. Deskripsi
                const Text('Overview',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  detail.description,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _infoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}