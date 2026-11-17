import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/auth_service.dart';
import 'services/library_service.dart';

Future<void> main() async {
  // Wajib kalau main() memanggil kode async sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Siapkan Hive, lalu buka box "library"
  await Hive.initFlutter();
  await Hive.openBox(LibraryService.boxName);

  // Cek status login sebelum app tampil
  final bool loggedIn = await AuthService().isLoggedIn();

  runApp(MyApp(isLoggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydra Games',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      // Sudah login -> langsung ke MainPage, belum -> LoginPage
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}