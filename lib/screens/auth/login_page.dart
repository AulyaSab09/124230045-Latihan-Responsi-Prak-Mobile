import 'package:flutter/material.dart';
import 'package:tugasakhir_124230045/repositories/user_repository.dart';
import 'package:tugasakhir_124230045/services/session_service.dart';  // Import session service
import 'package:tugasakhir_124230045/screens/main_navigation_page.dart';  // Halaman utama setelah login
import 'package:tugasakhir_124230045/screens/auth/register_page.dart';  // Halaman register

class LoginPage extends StatefulWidget {
  final UserRepository repo;
  const LoginPage({super.key, required this.repo});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "";
  String password = "";
  bool showPassword = false;

  Future<void> _login() async {
    bool success = widget.repo.checkLogin(username, password);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login gagal! Username atau password salah."),
        ),
      );
      return;
    }

    // ✅ Simpan session login
    await SessionService.saveLogin(username);

    // Arahkan ke halaman utama setelah login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigationPage(username: username, repo: widget.repo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      appBar: AppBar(
        title: const Text(
          "Anichive",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF850E35),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Logo
            CircleAvatar(
              radius: 70,
              backgroundColor: const Color(0xFFFFC4C4),
              backgroundImage: const AssetImage("assets/images/logo.png"),
            ),
            const SizedBox(height: 25),
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF850E35),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Login untuk mengakses lebih banyak fitur",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 25),
            // Username Field
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: Color(0xFF850E35)),
                labelText: "Username",
                filled: true,
                fillColor: const Color(0xFFFFC4C4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (v) => username = v,
            ),
            const SizedBox(height: 15),
            // Password Field
            TextField(
              obscureText: !showPassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: Color(0xFF850E35)),
                labelText: "Password",
                filled: true,
                fillColor: const Color(0xFFFFC4C4),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF850E35),
                  ),
                  onPressed: () {
                    setState(() => showPassword = !showPassword);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (v) => password = v,
            ),
            const SizedBox(height: 30),
            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFFEE6983),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text("Login", style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 10),
            // Register Link
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegisterPage(repo: widget.repo),
                  ),
                );
              },
              child: const Text(
                "Belum punya akun? Register",
                style: TextStyle(
                  color: Color(0xFF850E35),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
