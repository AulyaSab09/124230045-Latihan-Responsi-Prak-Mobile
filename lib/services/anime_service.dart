import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugasakhir_124230045/models/anime_model.dart';

class AnimeService {
  final String baseUrl = "https://api.jikan.moe/v4/top/anime";

  Future<List<AnimeModel>> fetchAnime() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List list = jsonData['data'];
      return list.map((e) => AnimeModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data anime");
    }
  }
}
