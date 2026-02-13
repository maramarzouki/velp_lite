import 'package:velp_lite/core/entities/user_entity.dart';
import 'package:velp_lite/core/models/user_model.dart';
import 'package:velp_lite/core/services/user_db_helper.dart';

class UserRepository {
  final UserDbHelper db;
  UserRepository({required this.db});

  Future<UserEntity> createUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    final createdUser = await db.createUser(userModel);
    return createdUser.toEntity();
  }

  Future<List<UserEntity>> getUsers() async {
    final users = await db.getUsers();
    return users.map((e) => e.toEntity()).toList();
  }

  Future<UserEntity> getUser(int id) async {
    final user = await db.getUser(id);
    return user.toEntity();
  }
  
  Future<int> updateUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    return await db.updateUser(userModel);
  }

  Future<int> deleteUser(int id) async {
    return await db.deleteUser(id);
  }
}