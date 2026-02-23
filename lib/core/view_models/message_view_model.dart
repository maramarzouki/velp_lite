import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/entities/message_entity.dart';
import 'package:velp_lite/core/providers/message_providers.dart';
import 'package:velp_lite/core/repositories/message_repository.dart';

class MessageViewModel extends AsyncNotifier<List<MessageEntity>> {
  late final MessageRepository _repo;
  final int roomId;

  MessageViewModel(this.roomId);
  
  @override
  Future<List<MessageEntity>> build() async {
    _repo = ref.read(messageRepositoryProvider);
    return await _repo.getMessages(roomId);
  } 

  Future<MessageEntity> addMessage(MessageEntity msg) async {
    state = AsyncLoading();
    try {
      final newMessage = await _repo.addMessage(msg);
      final updatedList = [...state.value ?? <MessageEntity>[], newMessage];
      state = AsyncData(updatedList);
      return newMessage;
    } catch (e) {
      debugPrint('Error adding msg: $e');
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<MessageEntity> getLastMessage(int roomId, int msgID) async {
    try {
      return await _repo.getLastMessage(roomId, msgID);
    } catch (e) {
      debugPrint('Error getting last message: $e');
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  // Future<void> updateMessage(MessageEntity msg) async {
  //   state = const AsyncLoading();
  //   try {
  //     final rowsAffected = await ref.read(messageRepositoryProvider).updateMessage(msg);
  //     if (rowsAffected == 0) {
  //       throw Exception('Failed to update msg');
  //     }

  //     final currentList = [...state.value ?? []];
  //     final index = currentList.indexWhere((p) => p.id == msg.id);
  //     if (index != -1) {
  //       currentList[index] = msg;
  //       state = AsyncData(currentList);
  //     }
  //   } catch (e) {
  //     debugPrint('Error updating msg: $e');
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }

  // Future<void> deleteMessage(int id) async {
  //   state = const AsyncLoading();
  //   try {
  //     final rowsAffected = await ref.read(messageRepositoryProvider).deleteMessage(id);
  //     if (rowsAffected == 0) {
  //       throw Exception('No msg deleted (ID $id not found?)');
  //     }

  //     final currentList = [...state.value ?? []];
  //     final updatedList = currentList.where((p) => p.id != id).toList();
  //     state = AsyncData(updatedList);
  //   } catch (e) {
  //     debugPrint('Error deleting msg: $e');
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }
}
