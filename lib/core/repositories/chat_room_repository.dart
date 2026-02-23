import 'package:velp_lite/core/entities/chat_room_entity.dart';
import 'package:velp_lite/core/models/chat_room_model.dart';
import 'package:velp_lite/core/services/chat_room_db_helper.dart';

class ChatRoomRepository {
  final ChatRoomDbHelper db;
  ChatRoomRepository({required this.db});

  Future<ChatRoomEntity> createChatRoom(ChatRoomEntity chatRoom) async {
    final chatRoomModel = ChatRoomModel.fromEntity(chatRoom);
    final createdChatRoom = await db.createChatRoom(chatRoomModel);
    return createdChatRoom.toEntity();
  }

  Future<List<ChatRoomEntity>> getChatRooms(int userId) async {
    final chatRooms = await db.getChatRooms(userId);
    return chatRooms.map((e) => e.toEntity()).toList();
  }

  Future<int> updateChatRoomLastMessageId(int chatRoomId, int messageId) async {
    return await db.updateChatRoomLastMessageId(chatRoomId, messageId);
  }

  Future<ChatRoomEntity> getChatRoom(int senderId, int id) async {
    final chatRoom = await db.getChatRoom(senderId, id);
    return chatRoom.toEntity();
  }

  Future<ChatRoomEntity?> getChatRoomByReceiver(int senderId, int receiverId, String receiverType) async {
    final chatRoom = await db.getChatRoomByReceiver(senderId, receiverId, receiverType);
    return chatRoom?.toEntity();
  }

  Future<void> deleteChatRoom(int id) async {
    await db.deleteChatRoom(id);
  }
}
