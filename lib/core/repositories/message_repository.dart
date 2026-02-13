import 'package:velp_lite/core/entities/message_entity.dart';
import 'package:velp_lite/core/models/message_model.dart';
import 'package:velp_lite/core/services/message_db_helper.dart';

class MessageRepository {
  // final MessageDbHelper db = MessageDbHelper.instance;

  final MessageDbHelper db;
  MessageRepository({required this.db});

  Future<MessageEntity> addMessage(MessageEntity message) async {
    final messageModel = MessageModel.fromEntity(message);
    final createdMessage = await db.createMessage(messageModel);
    return createdMessage.toEntity();
  }

  Future<List<MessageEntity>> getMessages() async {
    final messages = await db.getMessages();
    return messages.map((e) => e.toEntity()).toList();
  }

  Future<MessageEntity> getMessage(int id) async {
    final message = await db.getMessage(id);
    return message.toEntity();
  }

  Future<int> updateMessage(MessageEntity message) async {
    final messageModel = MessageModel.fromEntity(message);
    return await db.updateMessage(messageModel);
  }

  Future<int> deleteMessage(int id) async {
    return await db.deleteMessage(id);
  }
}
