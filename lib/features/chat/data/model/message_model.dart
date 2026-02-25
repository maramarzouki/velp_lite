import 'package:velp_lite/features/chat/data/entity/message_entity.dart';

class MessageModel {
  int? id;
  int sender;
  String senderType;
  String content;
  DateTime timestamp;
  int roomId;
  String contentType;

  MessageModel({
    this.id,
    required this.sender,
    required this.senderType,
    required this.content,
    required this.timestamp,
    required this.roomId,
    required this.contentType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': sender,
      'sender_type': senderType,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'room_id': roomId,
      'content_type': contentType,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      sender: map['sender_id'],
      senderType: map['sender_type'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      roomId: map['room_id'],
      contentType: map['content_type'],
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      sender: sender,
      senderType: senderType,
      content: content,
      timestamp: timestamp,
      roomId: roomId,
      contentType: contentType,
    );
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      sender: entity.sender,
      senderType: entity.senderType,
      content: entity.content,
      timestamp: entity.timestamp,
      roomId: entity.roomId,
      contentType: entity.contentType,
    );
  }
}
