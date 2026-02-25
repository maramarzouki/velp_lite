import 'package:velp_lite/features/chat/data/model/chat_room_model.dart';
import 'package:velp_lite/core/services/database_helper.dart';

class ChatRoomDbHelper {
  static final ChatRoomDbHelper instance = ChatRoomDbHelper._init();
  ChatRoomDbHelper._init();

  Future<ChatRoomModel> createChatRoom(ChatRoomModel chatRoom) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final id = await db.insert('chat_rooms', chatRoom.toMap());
      chatRoom.id = id;
      return chatRoom;
    } catch (e) {
      throw Exception('Failed to create chat room: $e');
    }
  }

  Future<List<ChatRoomModel>> getChatRooms(int userId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'chat_rooms',
        where: 'sender_id = ? AND sender_type = ?',
        whereArgs: [userId, 'user'],
      );
      return maps.map((m) => ChatRoomModel.fromMap(m)).toList();
    } catch (e) {
      throw Exception('Failed to get chat rooms: $e');
    }
  }

  Future<int> updateChatRoomLastMessageId(int chatRoomId, int messageId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      return await db.update(
        'chat_rooms',
        {'last_message_id': messageId},
        where: 'id = ?',
        whereArgs: [chatRoomId],
      );
    } catch (e) {
      throw Exception('Failed to update chat room last message id: $e');
    }
  }

  Future<ChatRoomModel> getChatRoom(int senderId, int id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final maps = await db.query(
        'chat_rooms',
        where: 'sender_id = ? AND id = ?',
        whereArgs: [senderId, id],
      );
      return ChatRoomModel.fromMap(maps.first);
    } catch (e) {
      throw Exception('Failed to get chat room: $e');
    }
  }

  // Future<ChatRoomModel?> getChatRoomByReceiver(int vetId, String receiverType) async {
  //   try {
  //     final db = await DatabaseHelper.instance.database;
  //     final maps = await db.query(
  //       'chat_rooms',
  //       where: 'receiver_id = ? AND receiver_type = ?',
  //       whereArgs: [vetId, receiverType],
  //     );

  //     if (maps.isNotEmpty) {
  //       return ChatRoomModel.fromMap(maps.first);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to get chat room by vet id: $e');
  //   }
  // }

  Future<ChatRoomModel?> getChatRoomByReceiver(
    int senderId,
    int receiverId,
    String receiverType,
  ) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final maps = await db.query(
        'chat_rooms',
        where:
            'sender_id = ? AND sender_type = ? AND receiver_id = ? AND receiver_type = ?',
        whereArgs: [senderId, 'user', receiverId, receiverType],
      );
      if (maps.isNotEmpty) {
        return ChatRoomModel.fromMap(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get chat room by receiver: $e');
    }
  }

  Future<int> deleteChatRoom(int id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('messages', where: 'room_id = ?', whereArgs: [id]);
      return await db.delete('chat_rooms', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete chat room: $e');
    }
  }
}
