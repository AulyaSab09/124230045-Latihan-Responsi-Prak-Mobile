import 'package:shared_preferences/shared_preferences.dart';

class PhotoManager {
  static const String photoKey = "user_photo";

  // Simpan path foto
  static Future<void> savePhoto(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(photoKey, path);
  }

  // Ambil foto
  static Future<String?> getPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(photoKey);
  }
}
