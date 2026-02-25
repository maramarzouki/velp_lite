import 'package:velp_lite/features/chat/data/model/message_model.dart';
import 'package:velp_lite/core/services/database_helper.dart';

class MessageDbHelper {
  static final MessageDbHelper instance = MessageDbHelper._init();
  MessageDbHelper._init();

  Future<MessageModel> createMessage(MessageModel message) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final id = await db.insert('messages', message.toMap());
      message.id = id;
      return message;
    } catch (e) {
      throw Exception('Failed to create message: $e');
    }
  }

  Future<List<MessageModel>> getMessages(int roomId) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('messages', where: 'room_id = ? AND sender_type = ?', whereArgs: [roomId, 'user']);
      return maps.map((m) => MessageModel.fromMap(m)).toList();
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  Future<MessageModel> getMessage(int id) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final maps = await db.query('messages', where: 'id = ?', whereArgs: [id]);

      if (maps.isNotEmpty) {
        return MessageModel.fromMap(maps.first);
      } else {
        throw Exception('Message not found');
      }
    } catch (e) {
      throw Exception('Failed to get message: $e');
    }
  }

  Future<MessageModel> getLastMessage(int roomId, int msgID) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final maps = await db.query(
        'messages',
        where: 'room_id = ? AND id = ?',
        whereArgs: [roomId, msgID],
      );
      if (maps.isNotEmpty) {
        return MessageModel.fromMap(maps.first);
      } else {
        throw Exception('Last message not found');
      }
    } catch (e) {
      throw Exception('Failed to get last message: $e');
    }
  }

  Future<int> updateMessage(MessageModel message) async {
    final db = await DatabaseHelper.instance.database;
    try {
      return await db.update(
        'messages',
        message.toMap(),
        where: 'id = ?',
        whereArgs: [message.id],
      );
    } catch (e) {
      throw Exception('Failed to update message: $e');
    }
  }

  Future<int> deleteMessage(int id) async {
    final db = await DatabaseHelper.instance.database;
    try {
      return await db.delete('messages', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }
}
