class ChatRoomEntity {
  final int? id;
  final int sender;
  final int receiver;
  final int lastMessageId;
  final int isSeen;
  final String senderType;
  final String receiverType;
  final DateTime createdAt;

  ChatRoomEntity({
    this.id,
    required this.sender,
    required this.senderType,
    required this.receiver,
    required this.receiverType,
    required this.lastMessageId,
    required this.isSeen,
    required this.createdAt,
  });

  ChatRoomEntity copyWith({
    int? id,
    int? sender,
    String? senderType,
    int? receiver,
    String? receiverType,
    int? lastMessageId,
    int? isSeen,
    DateTime? createdAt,
  }) => ChatRoomEntity(
    id: id ?? this.id,
    sender: sender ?? this.sender,
    senderType: senderType ?? this.senderType,
    receiver: receiver ?? this.receiver,
    receiverType: receiverType ?? this.receiverType,
    lastMessageId: lastMessageId ?? this.lastMessageId,
    isSeen: isSeen ?? this.isSeen,
    createdAt: createdAt ?? this.createdAt,
  );

  String get emoji => '🧑🏻‍⚕️';
  bool get isOnline => true;

  @override
  String toString() {
    return 'ChatRoomEntity(id: $id, sender: $sender, senderType: $senderType, receiver: $receiver, receiverType: $receiverType, lastMessageId: $lastMessageId, isSeen: $isSeen, createdAt: $createdAt)';
  }
}
