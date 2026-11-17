import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyEmail = '124@gmail.com';
  static const String _keyPassword = 'password';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  // Simpan data akun saat login
  Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // Cek apakah user sudah login (dipakai di main.dart untuk menentukan halaman awal)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Ambil email (dipakai di Profile Page)
  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? '-';
  }

  // Logout: hapus semua data login
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}