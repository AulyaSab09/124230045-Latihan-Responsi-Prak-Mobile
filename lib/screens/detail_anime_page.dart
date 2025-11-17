import 'package:flutter/material.dart';
import 'package:tugasakhir_124230045/models/anime_model.dart';
import 'package:tugasakhir_124230045/services/favorite_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimeDetailPage extends StatefulWidget {
  final AnimeModel anime;
  final VoidCallback onFavoriteChanged;


  const AnimeDetailPage({
    super.key, 
    required this.anime,
    required this.onFavoriteChanged,

  });

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  bool isFavorite = false;
  late int favoriteCount;

  @override
  void initState() {
    super.initState();
    favoriteCount = widget.anime.favorites;
    _loadFavoriteState();
  }

  Future<void> _loadFavoriteState() async {
    final fav = await FavoriteService.isFavorite(widget.anime.title);
    setState(() {
      isFavorite = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    await FavoriteService.toggleFavorite(widget.anime.title);

    setState(() {
      if (isFavorite) {
        isFavorite = false;
        if (favoriteCount > 0) favoriteCount--;
      } else {
        isFavorite = true;
        favoriteCount++;
      }
    });

      widget.onFavoriteChanged();
  }

  Future<void> _openAnimePage() async {
  final urlString = widget.anime.url;   // ambil URL anime
  print("URL yang akan dibuka: $urlString");  // Debugging: lihat URL-nya

  if (urlString.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Link anime tidak tersedia.")),
    );
    return;
  }

  final uri = Uri.parse(urlString);  // pastikan URL-nya valid

  // Gunakan canLaunchUrl dan launchUrl (Metode terbaru)
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);  // buka di aplikasi browser
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gagal membuka halaman anime.")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final anime = widget.anime;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF850E35),
        title: const Text("Detail Anime"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================== CARD ATAS ==================
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC4C4),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  // Poster kiri
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      anime.poster,
                      width: 110,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Info kanan
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title utama
                        Text(
                          anime.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF850E35),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Title english
                        Text(
                          (anime.titleEnglish.isEmpty || anime.titleEnglish == '-' )
                          ? anime.title
                          : anime.titleEnglish,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Score & Favorites dalam 1 baris
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color(0xFFDAA520), size: 18),
                            const SizedBox(width: 4),
                            Text(
                              anime.score.toString(),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                            const SizedBox(width: 12),

                            const Icon(Icons.favorite,
                                color: Color(0xFFEE6983), size: 18),
                            const SizedBox(width: 4),
                            Text(
                              favoriteCount.toString(),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),

                            const Spacer(),

                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? const Color(0xFFEE6983)
                                    : const Color(0xFF850E35),
                              ),
                              onPressed: _toggleFavorite,
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Button trailer
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _openAnimePage,        // ✅ pakai fungsi baru
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEE6983),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text(
                              "Lihat di MyAnimeList",        // ✅ teks baru (bebas kamu ganti)
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================== DESCRIPTION ==================
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF850E35),
              ),
            ),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC4C4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                anime.synopsis,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 20),

            // ================== GENRES ==================
            if (anime.genres.isNotEmpty) ...[
              const Text(
                "Genres",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF850E35),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: anime.genres.map((g) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF850E35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      g,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFFCF5EE),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
