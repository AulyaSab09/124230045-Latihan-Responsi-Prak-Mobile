import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tugasakhir_124230045/models/user_model.dart';
import 'package:tugasakhir_124230045/repositories/user_repository.dart';
import 'package:tugasakhir_124230045/screens/auth/login_page.dart';
import 'package:tugasakhir_124230045/services/session_service.dart';

class ProfilePage extends StatelessWidget {
  final String username;      // username yang sedang login
  final UserRepository repo;

  const ProfilePage({
    super.key,
    required this.username,
    required this.repo,
  });

  Future<void> logout(BuildContext context) async {
    await SessionService.logout(); // ✅ hapus session login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage(repo: repo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ambil data user dari database (Hive)
    final UserModel? user = repo.getUser(username);

    // data nama & NIM asli kamu (hardcode)
    const String namaLengkap = "Sabrina Nurul Aulya"; // ganti dengan nama kamu
    const String nim = "124230045";                 // ganti kalau beda

    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF850E35),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // FOTO (dari database; fallback ke icon kalau belum ada)
              CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xFFFFC4C4),
                backgroundImage: (user != null && user.photoPath != null)
                    ? FileImage(File(user.photoPath!))
                    : null,
                child: (user == null || user.photoPath == null)
                    ? const Icon(Icons.person,
                        size: 50, color: Color(0xFF850E35))
                    : null,
              ),

              const SizedBox(height: 20),

              // NAMA & NIM (statis / hardcode)
              Text(
                namaLengkap,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF850E35),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                "NIM: $nim",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // USERNAME (WAJIB dari database)
              Text(
                "Username: ${user?.username ?? username}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEE6983),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
