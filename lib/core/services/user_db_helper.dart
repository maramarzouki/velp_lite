import 'package:velp_lite/core/models/user_model.dart';
import 'package:velp_lite/core/services/database_helper.dart';

class UserDbHelper {
  static final UserDbHelper instance = UserDbHelper._init();
  UserDbHelper._init();

  Future<UserModel> createUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('users', user.toMap());
    user.id = id;
    return user;
  }

  Future<List<UserModel>> getUsers() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((m) => UserModel.fromMap(m)).toList();
  }

  Future<UserModel> getUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    } else {
      throw Exception('User not found');
    }
  }

  Future<int> updateUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
