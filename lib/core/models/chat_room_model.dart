import 'package:velp_lite/core/entities/chat_room_entity.dart';

class ChatRoomModel {
  int? id;
  int sender;
  int receiver;
  String senderType;
  String receiverType;
  int lastMessageId;
  int isSeen;
  DateTime createdAt;

  ChatRoomModel({
    this.id,
    required this.sender,
    required this.receiver,
    required this.senderType,
    required this.receiverType,
    required this.lastMessageId,
    required this.isSeen,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': sender,
      'receiver_id': receiver,
      'sender_type': senderType,
      'receiver_type': receiverType,
      'last_message_id': lastMessageId,
      'is_seen': isSeen,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'],
      sender: map['sender_id'],
      receiver: map['receiver_id'],
      senderType: map['sender_type'],
      receiverType: map['receiver_type'],
      lastMessageId: map['last_message_id'],
      isSeen: map['is_seen'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  ChatRoomEntity toEntity() {
    return ChatRoomEntity(
      id: id,
      sender: sender,
      receiver: receiver,
      senderType: senderType,
      receiverType: receiverType,
      lastMessageId: lastMessageId,
      isSeen: isSeen,
      createdAt: createdAt,
    );
  }

  factory ChatRoomModel.fromEntity(ChatRoomEntity entity) {
    return ChatRoomModel(
      id: entity.id,
      sender: entity.sender,
      receiver: entity.receiver,
      senderType: entity.senderType,
      receiverType: entity.receiverType,
      lastMessageId: entity.lastMessageId,
      isSeen: entity.isSeen,
      createdAt: entity.createdAt,
    );
  }
}
