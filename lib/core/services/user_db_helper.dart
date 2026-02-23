import 'package:flutter/foundation.dart';
import 'package:velp_lite/core/models/user_model.dart';
import 'package:velp_lite/core/services/database_helper.dart';
import 'package:bcrypt/bcrypt.dart';

class UserDbHelper {
  static final UserDbHelper instance = UserDbHelper._init();
  UserDbHelper._init();

  String _hashPasswordIsolate(String plain) {
    final salt = BCrypt.gensalt();
    return BCrypt.hashpw(plain, salt);
  }

  Future<UserModel> createUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [user.email],
      );
      if (maps.isNotEmpty) {
        throw Exception('Email already exists');
      }
      final String hashed = await compute(_hashPasswordIsolate, user.password);
      user.password = hashed;
      final id = await db.insert('users', user.toMap());
      user.id = id;
      return user;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // login user
  Future<UserModel> loginUser(String email, String password) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      if (maps.isEmpty) {
        throw Exception('User not found');
      }
      final user = UserModel.fromMap(maps.first);
      final isPasswordCorrect = BCrypt.checkpw(password, user.password);
      if (!isPasswordCorrect) {
        throw Exception('Incorrect password');
      }
      return user;
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  Future<List<UserModel>> getUsers() async {
    final db = await DatabaseHelper.instance.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('users');
      return maps.map((m) => UserModel.fromMap(m)).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  Future<UserModel> getUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
      if (maps.isNotEmpty) {
        return UserModel.fromMap(maps.first);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<int> updateUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;
    try {
      return await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<int> deleteUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    try {
      return await db.delete('users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
