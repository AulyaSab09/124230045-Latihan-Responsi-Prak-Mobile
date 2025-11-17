import 'package:flutter/material.dart';
import 'package:tugasakhir_124230045/repositories/user_repository.dart';
import 'package:tugasakhir_124230045/services/session_service.dart';
import 'package:tugasakhir_124230045/screens/auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final UserRepository repo;

  const ProfilePage({
    super.key,
    required this.username,
    required this.repo,
  });

  Future<void> logout(BuildContext context) async {
    await SessionService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage(repo: repo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFFFC4C4),
              child: Icon(Icons.person, size: 50, color: Color(0xFF850E35)),
            ),

            const SizedBox(height: 20),
            Text(
              username,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF850E35),
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () => logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEE6983),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14)
              ),
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
