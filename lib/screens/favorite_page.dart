import 'package:flutter/material.dart';
import 'package:tugasakhir_124230045/models/anime_model.dart';
import 'package:tugasakhir_124230045/services/anime_service.dart';
import 'package:tugasakhir_124230045/services/favorite_service.dart';
import 'package:tugasakhir_124230045/screens/detail_anime_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<AnimeModel>> allAnime;

  @override
  void initState() {
    super.initState();
    allAnime = AnimeService().fetchAnime();
  }

  void _confirmRemoveFavorite(String title) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Favorite"),
        content: const Text("Apakah kamu yakin ingin menghapus anime ini?"),
        actions: [
          TextButton(
            child: const Text("Tidak"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Iya"),
            onPressed: () async {
              await FavoriteService.toggleFavorite(title);
              Navigator.pop(context);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),

      appBar: AppBar(
        backgroundColor: const Color(0xFF850E35),
        title: const Text("Favorite Anime"),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: allAnime,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final all = snapshot.data!;
          return FutureBuilder(
            future: FavoriteService.getFavorites(),
            builder: (context, favSnapshot) {
              if (!favSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final favTitles = favSnapshot.data!;
              final favoriteAnime = all
                  .where((anime) => favTitles.contains(anime.title))
                  .toList();

              if (favoriteAnime.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada anime favorit",
                    style: TextStyle(
                        color: Color(0xFF850E35),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                itemCount: favoriteAnime.length,
                itemBuilder: (context, index) {
                  final anime = favoriteAnime[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AnimeDetailPage(
                            anime: anime,
                            onFavoriteChanged: () {
                              setState(() {}); // refresh favorite ketika balik dari detail
                            },
                          ),
                        ),
                      );
                    },

                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC4C4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          // Poster kiri
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              anime.poster,
                              width: 110,
                              height: 165,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Judul & Score
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  anime.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF850E35),
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Color(0xFFDAA520), size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      anime.score.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Love Button (selalu filled)
                          IconButton(
                            icon: const Icon(Icons.favorite,
                                color: Color(0xFFEE6983), size: 28),
                            onPressed: () {
                              _confirmRemoveFavorite(anime.title);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
