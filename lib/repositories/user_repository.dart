import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserRepository {
  static const String boxName = "usersBox";

  final Box<UserModel> box;

  UserRepository(this.box);

  Future<void> addUser(UserModel user) async {
    await box.put(user.username, user);
  }

  UserModel? getUser(String username) {
    return box.get(username);
  }

  bool checkLogin(String username, String password) {
    final user = box.get(username);
    if (user == null) return false;
    return user.password == password;
  }
}
