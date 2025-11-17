import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugasakhir_124230045/models/user_model.dart';
import 'package:tugasakhir_124230045/repositories/user_repository.dart';
import 'package:tugasakhir_124230045/screens/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  final UserRepository repo;
  const RegisterPage({super.key, required this.repo});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username = "";
  String password = "";
  bool showPassword = false;
  File? imageFile;

  final picker = ImagePicker();

  /// BottomSheet untuk milih Kamera / Galeri
  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(0xFF850E35)),
                title: Text("Ambil dari Kamera"),
                onTap: () async {
                  Navigator.pop(context);
                  final picked =
                      await picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    setState(() => imageFile = File(picked.path));
                  }
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.photo_library, color: Color(0xFF850E35)),
                title: Text("Pilih dari Galeri"),
                onTap: () async {
                  Navigator.pop(context);
                  final picked =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => imageFile = File(picked.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _register() async {
    if (username.isEmpty || password.isEmpty || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Isi semua field & upload foto!")),
      );
      return;
    }

    final user = UserModel(username: username, password: password);
    await widget.repo.addUser(user);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Register berhasil! Silakan login.")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage(repo: widget.repo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF5EE),

      /// AppBar tanpa panah
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Register Akun",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF850E35),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),

            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 65,
                backgroundColor: Color(0xFFFFC4C4),
                backgroundImage:
                    imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null
                    ? Icon(Icons.camera_alt,
                        size: 40, color: Color(0xFF850E35))
                    : null,
              ),
            ),

            SizedBox(height: 20),

            /// USERNAME FIELD
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, color: Color(0xFF850E35)),
                labelText: "Username",
                filled: true,
                fillColor: Color(0xFFFFC4C4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (v) => username = v,
            ),

            SizedBox(height: 15),

            /// PASSWORD FIELD
            TextField(
              obscureText: !showPassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Color(0xFF850E35)),
                labelText: "Password",
                filled: true,
                fillColor: Color(0xFFFFC4C4),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color(0xFF850E35),
                  ),
                  onPressed: () =>
                      setState(() => showPassword = !showPassword),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (v) => password = v,
            ),

            SizedBox(height: 30),

            /// BUTTON REGISTER
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Color(0xFFEE6983),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text("Register", style: TextStyle(fontSize: 18)),
              ),
            ),

            SizedBox(height: 15),

            /// LINK LOGIN
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(repo: widget.repo),
                  ),
                );
              },
              child: Text(
                "Sudah punya akun? Login",
                style: TextStyle(
                  color: Color(0xFF850E35),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
