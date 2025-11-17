import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String keyFavorites = "favorite_anime";

  // Ambil daftar favorite (list string ID/title)
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyFavorites) ?? [];
  }

  // Simpan
  static Future<void> setFavorites(List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keyFavorites, list);
  }

  // Toggle favorite
  static Future<void> toggleFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList(keyFavorites) ?? [];

    if (favs.contains(title)) {
      favs.remove(title);
    } else {
      favs.add(title);
    }

    await prefs.setStringList(keyFavorites, favs);
  }

  // Cek apakah favorite
  static Future<bool> isFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList(keyFavorites) ?? [];
    return favs.contains(title);
  }
}
