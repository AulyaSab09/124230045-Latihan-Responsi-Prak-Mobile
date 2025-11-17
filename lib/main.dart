import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tugasakhir_124230045/repositories/user_repository.dart';
import 'package:tugasakhir_124230045/screens/auth/login_page.dart';
import 'models/user_model.dart';

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
      home: LoginPage(repo: repo),
      debugShowCheckedModeBanner: false,
    );
  }
}
