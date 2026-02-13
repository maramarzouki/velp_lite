class MessageEntity {
  int? id;
  int sender;
  String content;
  DateTime timestamp;
  int roomId;
  String contentType;

  MessageEntity({
    this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.roomId,
    required this.contentType,
  });
}
