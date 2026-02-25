import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/features/chat/data/entity/chat_room_entity.dart';
import 'package:velp_lite/core/providers/chat_room_providers.dart';
import 'package:velp_lite/features/chat/data/repository/chat_room_repository.dart';

class ChatRoomViewModel extends AsyncNotifier<List<ChatRoomEntity>> {
  // late final ChatRoomRepository _repo;
  late final ChatRoomRepository _repo = ref.read(chatRoomRepositoryProvider);
  final int userId;

  ChatRoomViewModel(this.userId);

  @override
  Future<List<ChatRoomEntity>> build() async {
    // _repo = ref.read(chatRoomRepositoryProvider);
    return await _repo.getChatRooms(userId);
  }

  Future<ChatRoomEntity> createChatRoom(ChatRoomEntity chatRoom) async {
    state = const AsyncLoading();
    try {
      final newChatRoom = await _repo.createChatRoom(chatRoom);
      final createdList = [...state.value ?? <ChatRoomEntity>[], newChatRoom];
      state = AsyncData<List<ChatRoomEntity>>(createdList);
      return newChatRoom;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  // Future<void> getChatRooms() async {
  //   state = const AsyncLoading();
  //   try {
  //     final chatRooms = await _repo.getChatRooms();
  //     state = AsyncData<List<ChatRoomEntity>>(chatRooms);
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //     rethrow;
  //   }
  // }

  Future<ChatRoomEntity> getChatRoom(int senderId, int id) async {
    state = const AsyncLoading();
    try {
      final chatRoom = await _repo.getChatRoom(senderId, id);
      return chatRoom;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<ChatRoomEntity?> getChatRoomByReceiver(int senderId, int receiverId, String receiverType) async {
    try {
      final chatRoom = await _repo.getChatRoomByReceiver(senderId, receiverId, receiverType);
      return chatRoom;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateChatRoomLastMessageId(
    int chatRoomId,
    int messageId,
  ) async {
    state = const AsyncLoading();
    try {
      final rowsAffected = await _repo.updateChatRoomLastMessageId(
        chatRoomId,
        messageId,
      );
      if (rowsAffected == 0) {
        throw Exception('Failed to update chat room last message id');
      }

      final currentList = [...state.value ?? <ChatRoomEntity>[]];
      final index = currentList.indexWhere((p) => p.id == chatRoomId);
      if (index != -1) {
        currentList[index] = currentList[index].copyWith(lastMessageId: messageId);
        state = AsyncData<List<ChatRoomEntity>>(currentList);
      }
    } catch (e) {
      debugPrint('Error updating chat room last message id: $e');
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteChatRoom(int id) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteChatRoom(id);
      final updatedList = state.value
          ?.where((chatRoom) => chatRoom.id != id)
          .toList();
      state = AsyncData<List<ChatRoomEntity>>(updatedList ?? []);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  // add refresh method
  // Future<void> refresh({int? senderId, int? roomId}) async {
  //   state = const AsyncLoading();
  //   try {
  //     if (roomId != null && senderId != null) {
  //       final chatRoom = await _repo.getChatRoom(senderId, roomId);
  //       state = AsyncData<List<ChatRoomEntity>>([chatRoom]);
  //     } else {
  //       final chatRooms = await _repo.getChatRooms(userId);
  //       state = AsyncData<List<ChatRoomEntity>>(chatRooms);
  //     }
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current); 
  //     rethrow;
  //   }
  // }
}
