import 'package:flutter/material.dart';
import 'package:tugasakhir_124230045/repositories/user_repository.dart';
import 'package:tugasakhir_124230045/screens/favorite_page.dart';
import 'package:tugasakhir_124230045/screens/home_page.dart';
import 'package:tugasakhir_124230045/screens/profile_page.dart';
import 'package:tugasakhir_124230045/services/session_service.dart'; // Import SessionService untuk pengecekan session
import 'package:tugasakhir_124230045/screens/auth/login_page.dart';  // Import halaman login

class MainNavigationPage extends StatefulWidget {
  final String username;
  final UserRepository repo;

  const MainNavigationPage({
    super.key,
    required this.username,
    required this.repo,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  // Untuk rebuild FavoritePage
  Key favKey = UniqueKey();

  void refreshFavorite() {
    setState(() {
      favKey = UniqueKey(); // rebuild FavoritePage
    });
  }

  // Fungsi untuk mengecek session login saat halaman dimulai
  Future<void> _checkLoginStatus() async {
    String? savedUsername = await SessionService.getLoggedInUser();
    if (savedUsername == null) {
      // Jika session login tidak ada, arahkan ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPage(repo: widget.repo),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();  // Mengecek session login saat halaman dimulai
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      AnimeHomePage(
        username: widget.username,
        repo: widget.repo,
        onFavoriteChanged: refreshFavorite,   // <-- Home memanggil reload Favorite
      ),
      // Favorite pasti refresh kalau favKey berubah
      FavoritePage(
        key: favKey,
      ),
      ProfilePage(
        username: widget.username,
        repo: widget.repo,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() => currentIndex = value);
        },
        selectedItemColor: const Color(0xFF850E35),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
