import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:velp_lite/core/entities/vet_entity.dart';
import 'package:velp_lite/core/providers/chat_room_providers.dart';
import 'package:velp_lite/core/providers/message_providers.dart';
import 'package:velp_lite/core/providers/user_providers.dart';
import 'package:velp_lite/core/providers/vet_providers.dart';
import 'package:velp_lite/core/theme/app_colors.dart';
import 'package:velp_lite/features/chat/presentation/screens/chat_screen.dart';

class ChatsListScreen extends ConsumerStatefulWidget {
  const ChatsListScreen({super.key});

  @override
  ConsumerState<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends ConsumerState<ChatsListScreen> {

  void _showNewChatDialog() {
    final vets = ref.watch(vetViewModelProvider);
    final userId = ref.watch(userViewModelProvider).value!.id;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 520),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: .9),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Message',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Choose a vet to chat with',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.white,
                            size: 20,
                          ),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Vets List
                Flexible(
                  child: vets.when(
                    data: (vets) {
                      if (vets.isEmpty) {
                        return const Center(child: Text('No vets found!'));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        itemCount: vets.length,
                        itemBuilder: (context, index) {
                          final vet = vets[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final chatRoom = await ref
                                    .read(
                                      chatRoomViewModelProvider(
                                        userId!,
                                      ).notifier,
                                    )
                                    .getChatRoomByReceiver(userId, vet.id!, 'vet');
                                if (chatRoom != null) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        vet: vet,
                                        roomID: chatRoom.id!,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(vet: vet),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    // Avatar
                                    Stack(
                                      children: [
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppColors.accent.withValues(
                                                  alpha: .3,
                                                ),
                                                AppColors.accent.withValues(
                                                  alpha: .1,
                                                ),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              vet.emoji,
                                              style: const TextStyle(
                                                fontSize: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // if (vet.isOnline)
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
                                                color: AppColors.background,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 14),

                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vet.name,
                                            style: const TextStyle(
                                              color: AppColors.text,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            vet.specialty,
                                            style: TextStyle(
                                              color: AppColors.lightText,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Online badge or arrow
                                    // if (vet.isOnline)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withValues(
                                          alpha: .2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Online',
                                        style: TextStyle(
                                          color: AppColors.accent.withValues(
                                            alpha: .9,
                                          ),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    // else
                                    //   Icon(
                                    //     Icons.chevron_right,
                                    //     color: AppColors.lightText,
                                    //     size: 20,
                                    //   ),
                                  ],
                                ),
                              ),
                            ),
                          );
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
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userViewModelProvider).value!.id;
    final chatRooms = ref.watch(chatRoomViewModelProvider(userId!));
    debugPrint('chatRooms in chat lists screen: ${chatRooms.value}');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Messages',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Chat with vets and clinics',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: _showNewChatDialog,
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: AppColors.white,
                    //     borderRadius: BorderRadius.circular(16),
                    //   ),
                    //   child: TextField(
                    //     controller: _searchController,
                    //     decoration: InputDecoration(
                    //       hintText: 'Search messages...',
                    //       prefixIcon: Icon(
                    //         Icons.search,
                    //         color: AppColors.accent,
                    //         size: 20,
                    //       ),
                    //       border: InputBorder.none,
                    //       contentPadding: const EdgeInsets.symmetric(
                    //         horizontal: 16,
                    //         vertical: 12,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  
                  
                  ],
                ),
              ),
            ),

            // Chats List
            Expanded(
              child: chatRooms.when(
                data: (chatRoom) {
                  if (chatRoom.isEmpty) {
                    return const Center(child: Text('No chat rooms found!'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                    itemCount: chatRoom.length,

                    itemBuilder: (context, index) {
                      final chat = chatRoom[index];

                      // watch the last message for this chat
                      final lastMessageAsync = ref.watch(
                        lastMessageProvider((chat.id!, chat.lastMessageId)),
                      );

                      final vetsAsyncValue = ref.watch(vetViewModelProvider);

                      // figure out vet id (same as your code)
                      final vetId = (chat.receiverType == 'vet')
                          ? chat.receiver
                          : (chat.senderType == 'vet')
                          ? chat.sender
                          : null;

                      // // vet info async value (fall back to an "empty" VetEntity so code can compile)
                      // final vetAsyncValue = vetId != null
                      //     ? ref.watch(vetInfoProvider(vetId))
                      //     : AsyncValue.data(
                      //         VetEntity(
                      //           id: 0,
                      //           name: '',
                      //           email: '',
                      //           phone: '',
                      //           specialty: '',
                      //           clinic: '',
                      //         ),
                      //       );

                      // IMPORTANT: return the result of `when` directly
                      return lastMessageAsync.when(
                        data: (lastMessage) {
                          // defend against lastMessage being null
                          if (lastMessage == null) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              child: Text('No last message'),
                            );
                          }

                          // handle vet async states inside the last message data handler
                          return vetsAsyncValue.when(
                            data: (vets) {
                              final VetEntity vet = vets.firstWhere(
                                (v) => v.id == vetId,
                                orElse: () => VetEntity(
                                  id: 0,
                                  name: 'Unknown',
                                  email: '',
                                  phone: '',
                                  specialty: '',
                                  clinic: '',
                                ),
                              );
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: .06,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChatScreen(
                                            vet: vet,
                                            roomID: chat.id!,
                                          ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          // Avatar
                                          Stack(
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      AppColors.accent
                                                          .withValues(
                                                            alpha: .3,
                                                          ),
                                                      AppColors.accent
                                                          .withValues(
                                                            alpha: .1,
                                                          ),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    chat.emoji,
                                                    style: const TextStyle(
                                                      fontSize: 32,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 16),

                                          // Chat Info
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        vet.name,
                                                        style: const TextStyle(
                                                          color: AppColors.text,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat(
                                                            'MMM d, yyyy hh:mm a',
                                                          )
                                                          .format(
                                                            lastMessage
                                                                .timestamp,
                                                          )
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: chat.isSeen == 1
                                                            ? AppColors.primary
                                                            : AppColors
                                                                  .lightText,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            chat.isSeen == 1
                                                            ? FontWeight.w600
                                                            : FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  vet.specialty,
                                                  style: TextStyle(
                                                    color: AppColors.lightText,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        lastMessage.content ??
                                                            '',
                                                        style: TextStyle(
                                                          color:
                                                              chat.isSeen == 1
                                                              ? AppColors.text
                                                              : AppColors
                                                                    .lightText,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              chat.isSeen == 1
                                                              ? FontWeight.w500
                                                              : FontWeight
                                                                    .normal,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            loading: () => SizedBox(
                              height: 90,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            error: (err, st) {
                              debugPrint('error loading last message: $err');
                              return Container(
                                padding: const EdgeInsets.all(16),
                                child: Text('Error loading vet: $err'),
                              );
                            },
                          );
                        },
                        loading: () => SizedBox(
                          height: 90,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (err, st) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            child: Text('Error loading last message: $err'),
                          );
                        },
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  debugPrint('error loading chat rooms: $error');
                  return Center(child: Text('Error: $error'));
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
