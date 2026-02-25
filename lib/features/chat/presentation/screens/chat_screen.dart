import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:velp_lite/features/chat/data/entity/chat_room_entity.dart';
import 'package:velp_lite/features/chat/data/entity/message_entity.dart';
import 'package:velp_lite/core/entities/vet_entity.dart';
import 'package:velp_lite/core/providers/chat_room_providers.dart';
import 'package:velp_lite/core/providers/message_providers.dart';
import 'package:velp_lite/core/providers/user_providers.dart';
import 'package:velp_lite/core/theme/app_colors.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final VetEntity vet;
  final int? roomID;
  // final bool isNewRoom;
  const ChatScreen({super.key, required this.vet, this.roomID});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String errorMessage = '';

  // the id of the room if it was just created
  int newRoomID = 0;

  // final List<ChatMessage> _messages = [
  //   ChatMessage(
  //     text: 'Hi! How can I help you with Luna today?',
  //     isSentByMe: false,
  //     time: '10:15 AM',
  //   ),
  //   ChatMessage(
  //     text:
  //         'Hello Dr. Wilson! I wanted to ask about Luna\'s recent checkup results.',
  //     isSentByMe: true,
  //     time: '10:16 AM',
  //   ),
  //   ChatMessage(
  //     text:
  //         'Of course! Luna\'s checkup results look great! 🎉 All her vitals are normal and she\'s in excellent health.',
  //     isSentByMe: false,
  //     time: '10:18 AM',
  //   ),
  //   ChatMessage(
  //     text: 'That\'s wonderful news! Should I schedule her next checkup?',
  //     isSentByMe: true,
  //     time: '10:20 AM',
  //   ),
  //   ChatMessage(
  //     text:
  //         'Yes, I recommend scheduling her next checkup in 6 months. You can book it through the app.',
  //     isSentByMe: false,
  //     time: '10:22 AM',
  //   ),
  //   ChatMessage(
  //     text: 'Perfect! Thank you so much for the update.',
  //     isSentByMe: true,
  //     time: '10:25 AM',
  //   ),
  //   ChatMessage(
  //     text:
  //         'You\'re welcome! Don\'t hesitate to reach out if you have any questions. Have a great day! 😊',
  //     isSentByMe: false,
  //     time: '10:30 AM',
  //   ),
  // ];

  Future<ChatRoomEntity?> createChatRoom(
    VetEntity vet,
    int lastMessageId,
  ) async {
    debugPrint('creating chat room');
    try {
      // id of last item in messages list
      final user = ref.read(userViewModelProvider);
      final chatRoom = ChatRoomEntity(
        sender: user.value!.id!,
        senderType: 'user',
        receiver: vet.id!,
        receiverType: 'vet',
        lastMessageId: lastMessageId,
        isSeen: 1,
        createdAt: DateTime.now(),
      );
      debugPrint('chat room: $chatRoom');
      final created = await ref
          .read(chatRoomViewModelProvider(user.value!.id!).notifier)
          .createChatRoom(chatRoom);
      if (created != null && created.id != null) {
        return created;
      }

      debugPrint('created chat room: $created');

      // Fallback: read provider after creation and return the last room (if any)
      final rooms = ref.read(chatRoomViewModelProvider(user.value!.id!));
      if (rooms.hasValue && rooms.value!.isNotEmpty) {
        return rooms.value!.last;
      }

      // Nothing available
      return null;
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to create chat room: ${e.toString()}';
      });
      return null;
    }
  }

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    try {
      final user = ref.read(userViewModelProvider);

      int roomId;
      if (widget.roomID != null) {
        roomId = widget.roomID!;
      } else if (newRoomID != 0) {
        roomId = newRoomID;
      } else {
        // for new chats
        final createdChatRoom = await createChatRoom(widget.vet, 0);
        if (createdChatRoom == null || createdChatRoom.id == null) {
          setState(() => errorMessage = 'Failed to create chat room');
          return;
        }
        roomId = createdChatRoom.id!;
        setState(() => newRoomID = roomId);
      }

      final message = MessageEntity(
        sender: user.value!.id!,
        senderType: 'user',
        content: content,
        timestamp: DateTime.now(),
        roomId: roomId,
        contentType: 'text',
      );
      final newMsg = await ref
          .read(messageViewModelProvider(roomId).notifier)
          .addMessage(message);

      if (newMsg.id != null) {
        await ref
            .read(chatRoomViewModelProvider(user.value!.id!).notifier)
            .updateChatRoomLastMessageId(roomId, newMsg.id!);
      }

      _messageController.clear();
      // if (content.trim().isEmpty) return;
      // try {
      //   debugPrint('contenttttt $content');
      //   final user = ref.read(userViewModelProvider);
      //   final chatRoomsAsync = ref.read(
      //     chatRoomViewModelProvider(user.value!.id!),
      //   );
      //   // final roomID = chatRooms.value!.last.id!;

      //   int? existingRoomId;
      //   if (chatRoomsAsync.hasValue && chatRoomsAsync.value!.isNotEmpty) {
      //     existingRoomId = chatRoomsAsync.value!.last.id;
      //   }

      //   int roomId;
      //   if (chatRoomsAsync.value!.isEmpty) {
      //     final createdChatRoom = await createChatRoom(widget.vet, 0);
      //     if (createdChatRoom == null || createdChatRoom.id == null) {
      //       setState(() {
      //         setState(() => errorMessage = 'Failed to create chat room');
      //         return;
      //       });
      //     }
      //     roomId = createdChatRoom!.id!;
      //     setState(() => newRoomID = roomId);
      //   } else {
      //     roomId = widget.roomID ?? existingRoomId ?? 0;
      //     if (roomId == 0) {
      //       setState(
      //         () => errorMessage = 'No chat room available to send message',
      //       );
      //       return;
      //     }
      //   }

      //   final message = MessageEntity(
      //     sender: user.value!.id!,
      //     senderType: 'user',
      //     content: content,
      //     timestamp: DateTime.now(),
      //     roomId: roomId,
      //     contentType: 'text',
      //   );
      //   final newMsg = await ref
      //       .read(messageViewModelProvider((roomId)).notifier)
      //       .addMessage(message);

      //   debugPrint('newMsg from out if: $newMsg');

      //   if (newMsg.id != null) {
      //     await ref
      //         .read(chatRoomViewModelProvider(user.value!.id!).notifier)
      //         .updateChatRoomLastMessageId(roomId, newMsg.id!);
      //   }

      //   _messageController.clear();
      if (_scrollController.hasClients) {
        // small delay to allow ListView to rebuild with new message
        Future.delayed(const Duration(milliseconds: 50), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to send message: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int? effectiveRoomId =
        widget.roomID ?? (newRoomID > 0 ? newRoomID : null);

    final userId = ref.watch(userViewModelProvider).value?.id ?? 0;
    final roomId = widget.roomID ?? newRoomID;
    final messages = ref.watch(messageViewModelProvider(roomId));

    debugPrint('messages: ${messages.value} roomId: $roomId, userId: $userId');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: .9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Back Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Avatar with online status
                    Stack(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.accent.withValues(alpha: .3),
                                AppColors.accent.withValues(alpha: .1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              widget.vet.emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        // if (chatUser['isOnline'] as bool)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Name and Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.vet.name,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            // chatUser['isOnline'] as bool ? 'Online' : 'Offline',
                            'Online',
                            style: TextStyle(
                              color: AppColors.white.withValues(alpha: .9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // More Options
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: AppColors.white.withValues(alpha: .2),
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: IconButton(
                    //     onPressed: () {},
                    //     icon: const Icon(
                    //       Icons.more_vert,
                    //       color: AppColors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            // Messages List
            Expanded(
              child: effectiveRoomId == null
                  ? const Center(child: Text('No messages yet'))
                  : messages.when(
                      data: (messages) {
                        if (messages.isEmpty) {
                          return const Center(
                            child: Text('No messages found!'),
                          );
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(20),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return _buildMessageBubble(message);
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        return Center(child: Text(error.toString()));
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                    ),
            ),
            //   child: ListView.builder(
            //     controller: _scrollController,
            //     padding: const EdgeInsets.all(20),
            //     itemCount: messages.value?.length ?? 0,
            //     itemBuilder: (context, index) {
            //       final message = messages.value?[index];
            //       return _buildMessageBubble(message);
            //     },
            //   ),
            // ),

            // Message Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Attachment Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.attach_file,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Text Input
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Send Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: .9),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: .4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () =>
                            _sendMessage(_messageController.text.trim()),
                        icon: const Icon(
                          Icons.send,
                          color: AppColors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageEntity message) {
    final user = ref.read(userViewModelProvider);
    bool isSentByMe = message.sender == user.value!.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isSentByMe) const SizedBox(width: 0),
          Flexible(
            child: Column(
              crossAxisAlignment: isSentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSentByMe
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: .9),
                            ],
                          )
                        : null,
                    color: isSentByMe ? null : AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isSentByMe ? 20 : 4),
                      bottomRight: Radius.circular(isSentByMe ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSentByMe
                            ? AppColors.primary.withValues(alpha: .3)
                            : Colors.black.withValues(alpha: .06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isSentByMe ? AppColors.white : AppColors.text,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM d, yyyy hh:mm a').format(message.timestamp),
                  style: TextStyle(color: AppColors.lightText, fontSize: 11),
                ),
              ],
            ),
          ),
          if (isSentByMe) const SizedBox(width: 0),
        ],
      ),
    );
  }
}
