class MessageEntity {
  int? id;
  int sender;
  String senderType;
  String content;
  DateTime timestamp;
  int roomId;
  String contentType;

  MessageEntity({
    this.id,
    required this.sender,
    required this.senderType,
    required this.content,
    required this.timestamp,
    required this.roomId,
    required this.contentType,
  });

  @override
  String toString() {
    return 'MessageEntity(id: $id, sender: $sender, senderType: $senderType, content: $content, timestamp: $timestamp, roomId: $roomId, contentType: $contentType)';
  }
}
