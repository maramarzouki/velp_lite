import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/entities/message_entity.dart';
import 'package:velp_lite/core/providers/message_providers.dart';
import 'package:velp_lite/core/repositories/message_repository.dart';

class MessageViewModel extends AsyncNotifier<List<MessageEntity>> {
  late final MessageRepository _repo;

  @override
  Future<List<MessageEntity>> build() async {
    _repo = await ref.read(messageRepositoryProvider);
    return await _repo.getMessages();
  }

  Future<void> addMessage(MessageEntity msg) async {
    state = const AsyncLoading();
    try {
      final newMessage = await _repo.addMessage(msg);
      final updatedList = [...state.value ?? [], newMessage];
      state = AsyncData(updatedList);
    } catch (e) {
      debugPrint('Error adding msg: $e');
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> getMessages(int id) async {
    try {
      await _repo.getMessage(id);
    } catch (e) {
      debugPrint('Error getting msg: $e');
      return;
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
