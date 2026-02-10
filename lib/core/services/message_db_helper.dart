import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/models/message_model.dart';
import 'package:velp_lite/core/services/database_helper.dart';

final messageDbHelperProvider = Provider<MessageDbHelper>((ref) => MessageDbHelper.instance);

class MessageDbHelper {
  static final MessageDbHelper instance = MessageDbHelper._init();
  MessageDbHelper._init();

  Future<MessageModel> createMessage(MessageModel message) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('messages', message.toMap());
    message.id = id;
    return message;
  }

  Future<List<MessageModel>> getMessages() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('messages');
    return maps.map((m) => MessageModel.fromMap(m)).toList();
  }

  Future<MessageModel> getMessage(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('messages', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return MessageModel.fromMap(maps.first);
    } else {
      throw Exception('Message not found');
    }
  }

  Future<int> updateMessage(MessageModel message) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'messages',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<int> deleteMessage(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete('messages', where: 'id = ?', whereArgs: [id]);
  }
}
