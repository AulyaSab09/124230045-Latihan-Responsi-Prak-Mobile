import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tugasakhir_124230045/repositories/user_repository.dart';
import 'package:tugasakhir_124230045/screens/auth/login_page.dart';
import 'package:tugasakhir_124230045/screens/main_navigation_page.dart';  // Ganti dengan halaman utama
import 'models/user_model.dart';
import 'services/session_service.dart';  // Import service untuk pengecekan session

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

  final box = await Hive.openBox<UserModel>(UserRepository.boxName);

  runApp(MyApp(repo: UserRepository(box)));
}

class MyApp extends StatelessWidget {
  final UserRepository repo;

  const MyApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<String?>(
        future: SessionService.getLoggedInUser(), // Mengecek session login
        builder: (context, snapshot) {
          // Jika data session sudah ada, langsung ke halaman utama
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Menunggu pengecekan session
          }

          if (snapshot.hasData && snapshot.data != null) {
            // Jika session login ada (user sudah login sebelumnya)
            return MainNavigationPage(username: snapshot.data!, repo: repo);  // Halaman utama setelah login
          } else {
            // Jika tidak ada session, arahkan ke halaman login
            return LoginPage(repo: repo);
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
