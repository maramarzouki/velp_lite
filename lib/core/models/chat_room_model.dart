class ChatRoomModel {
  int? id;
  int sender;
  String receiver;
  int lastMessageId;
  bool isSeen;
  DateTime createdAt;

  ChatRoomModel({
    this.id,
    required this.sender,
    required this.receiver,
    required this.lastMessageId,
    required this.isSeen,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'last_message_id': lastMessageId,
      'is_seen': isSeen,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'],
      sender: map['sender'],
      receiver: map['receiver'],
      lastMessageId: map['last_message_id'],
      isSeen: map['is_seen'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}