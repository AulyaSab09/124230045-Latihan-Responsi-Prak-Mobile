import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String keyUsername = "loggedInUser";

  // simpan session
  static Future<void> saveLogin(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUsername, username);
  }

  // ambil session user
  static Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUsername);
  }

  // hapus session
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUsername);
  }
}
