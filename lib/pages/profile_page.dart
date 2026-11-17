import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/auth_service.dart';
import '../services/library_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final LibraryService _libraryService = LibraryService();
  late Future<String> _futureEmail;

  @override
  void initState() {
    super.initState();
    _futureEmail = _authService.getEmail();
  }

  Future<void> _handleLogout() async {
    await _authService.logout();

    if (!mounted) return;

    // pushAndRemoveUntil dengan (route) => false: hapus SEMUA halaman di stack,
    // jadi user tidak bisa menekan back untuk kembali ke app setelah logout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white12,
              child: Icon(Icons.person, size: 56),
            ),
            const SizedBox(height: 40),

            // a-i. Email dari SharedPreferences
            FutureBuilder<String>(
              future: _futureEmail,
              builder: (context, snapshot) {
                return _infoRow('Email', snapshot.data ?? '...');
              },
            ),
            const SizedBox(height: 12),

            // a-ii. Jumlah game dari Hive (ikut berubah otomatis)
            ValueListenableBuilder<Box>(
              valueListenable: _libraryService.listenable,
              builder: (context, box, _) {
                return _infoRow('Games Dimiliki', '${_libraryService.count}');
              },
            ),

            const Spacer(),

            // b. Tombol logout
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}