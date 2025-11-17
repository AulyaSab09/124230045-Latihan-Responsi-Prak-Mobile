import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  // path file foto yang dipilih saat register
  @HiveField(2)
  String? photoPath;

  UserModel({
    required this.username,
    required this.password,
    this.photoPath,
  });
}
