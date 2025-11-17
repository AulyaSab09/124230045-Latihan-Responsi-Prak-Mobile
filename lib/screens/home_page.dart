import 'package:flutter/material.dart';
import 'package:tugasakhir_124230045/models/anime_model.dart';
import 'package:tugasakhir_124230045/screens/detail_anime_page.dart';
import 'package:tugasakhir_124230045/services/anime_service.dart';
import 'package:tugasakhir_124230045/services/favorite_service.dart';
import 'package:tugasakhir_124230045/services/session_service.dart';
import 'package:tugasakhir_124230045/repositories/user_repository.dart';
import 'package:tugasakhir_124230045/screens/auth/login_page.dart';

class AnimeHomePage extends StatefulWidget {
  final String username;
  final UserRepository repo;
  final VoidCallback onFavoriteChanged;


  const AnimeHomePage({
    super.key,
    required this.username,
    required this.repo,
    required this.onFavoriteChanged,  
  });

  @override
  State<AnimeHomePage> createState() => _AnimeHomePageState();
}

class _AnimeHomePageState extends State<AnimeHomePage> {
  final AnimeService animeService = AnimeService();
  late Future<List<AnimeModel>> animes;

  String searchText = "";

  @override
  void initState() {
    super.initState();
    animes = animeService.fetchAnime();
  }

  Future<void> logout() async {
    await SessionService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(repo: widget.repo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF850E35),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFFFC4C4),
              backgroundImage: const AssetImage("assets/images/logo.png"),
            ),

            const SizedBox(width: 10),
            const Text(
              "Anichive",
              style: TextStyle(
                  color: Color(0xFFFFC4C4),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout, color: Color(0xFFFFC4C4)),
          )
        ],
      ),

      body: SafeArea(
        child: FutureBuilder(
          future: animes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text("Gagal memuat data anime"));
            }

            final list = snapshot.data!;
            final filtered = list
                .where((anime) => anime.title
                    .toLowerCase()
                    .contains(searchText.toLowerCase()))
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // HALLO USER
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, top: 10, bottom: 4),
                  child: Text(
                    "Hallo, ${widget.username}!",
                    style: const TextStyle(
                      color: Color(0xFF850E35),
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // TAGLINE
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 12),
                  child: Text(
                    "Mau cari anime apa hari ini?",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                ),

                // SEARCH BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    onChanged: (value) {
                      setState(() => searchText = value);
                    },
                    decoration: InputDecoration(
                      hintText: "Cari anime...",
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF850E35)),
                      filled: true,
                      fillColor: const Color(0xFFFFC4C4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Jika pencarian tidak ada
                if (filtered.isEmpty && searchText.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Anime yang kamu cari tidak ditemukan.",
                      style: TextStyle(
                          color: Color(0xFF850E35),
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                // GRID ANIME
                if (filtered.isNotEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) =>
                            _animeCard(filtered[index]),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _animeCard(AnimeModel anime) {
    return FutureBuilder(
      future: FavoriteService.isFavorite(anime.title),
      builder: (context, snapshot) {
        final isFav = snapshot.data ?? false;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AnimeDetailPage(
                  anime: anime,
                  onFavoriteChanged: widget.onFavoriteChanged, // <-- pindah ke sini
                ),
              ),
            );
          },


          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFC4C4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    anime.poster,
                    height: 175,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 8),

                // JUDUL
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF850E35),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.star, size: 18, color: Color(0xFFDAA520)),
                    const SizedBox(width: 4),

                    Text(
                      anime.score.toString(),
                      style: const TextStyle(color: Colors.black87),
                    ),

                    const Spacer(),

                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav
                            ? const Color(0xFFEE6983)
                            : const Color(0xFF850E35),
                      ),
                      onPressed: () async {
                        await FavoriteService.toggleFavorite(anime.title);
                        setState(() {});
                        widget.onFavoriteChanged(); 
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
