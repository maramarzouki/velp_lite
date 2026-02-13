import 'package:velp_lite/core/entities/message_entity.dart';

class MessageModel {
  int? id;
  int sender;
  String content;
  DateTime timestamp;
  int roomId;
  String contentType;

  MessageModel({
    this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.roomId,
    required this.contentType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'content': content,
      'timestamp': timestamp,
      'room_id': roomId,
      'content_type': contentType,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      sender: map['sender'],
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
      content: entity.content,
      timestamp: entity.timestamp,
      roomId: entity.roomId,
      contentType: entity.contentType,
    );
  }
}
