// Sesuaikan dengan Key dari API
/* Deklarasikan key dari API ke variabel dart,
namanya disamakan saja */
class AnimeModel{
  final String poster;
  final String title;
  final double score;
  final String synopsis;
  final int favorites;
  final String trailerUrl;
  final List<String> genres;
  final String titleEnglish;

// Constructur
/* Jadi ketika kita ingin ambil nilai itu harus ada
dan ga mungkin kosong karena kita udah required */
  AnimeModel({
    required this.poster,
    required this.title,
    required this.score,
    required this.synopsis,
    required this.favorites,
    required this.trailerUrl,
    required this.genres,
    required this.titleEnglish,

  });

/* Factory = Konversi dari MAP json ke 
sebuah class AnimeModel */
  factory AnimeModel.fromJson(Map<String, dynamic> json){
      final genreList = (json['genres'] as List<dynamic>?)
            ?.map((g) => g['name'] as String? ?? '-')
            .toList() ??
        [];

    return AnimeModel(
      // Kayaknya kalau "?" hanya satu itu buat object deh
      // "??" seperti else if
      poster: json['images']?['jpg']?['image_url'] ?? 'Gambar Tidak Tersedia', 
      title: json['title'] ?? '-', 
      score: (json['score'] ?? 0).toDouble(), 
      synopsis: json['synopsis'] ?? 'Sinopsi Tidak Tersedia', 
       favorites: json['favorites'] ?? 0,
      trailerUrl: json['trailer']?['url'] ?? json['trailer']?['embed_url'] ?? '',
      genres: genreList,
      titleEnglish: json['title_english'] ?? '-',

    );
  }
}