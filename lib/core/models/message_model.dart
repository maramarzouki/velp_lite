class MessageModel {
  int? id;
  String sender;
  String content;
  String timestamp;

  MessageModel({
    this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      sender: map['sender'],
      content: map['content'],
      timestamp: map['timestamp'],
    );
  }

  

}
