import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/entities/user_entity.dart';
import 'package:velp_lite/core/providers/user_providers.dart';
import 'package:velp_lite/core/repositories/user_repository.dart';

class UserViewModel extends AsyncNotifier<List<UserEntity>> {
  late final UserRepository _repo;

  @override
  Future<List<UserEntity>> build() async {
    _repo = await ref.read(userRepositoryProvider);
    return await _repo.getUsers();
  }

  Future<UserEntity> createUser(UserEntity user) async {
    state = const AsyncLoading();
    try {
      final newUser = await _repo.createUser(user);
      final createdList = [...state.value ?? <UserEntity>[], newUser];
      state = AsyncData<List<UserEntity>>(createdList);
      return newUser;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateUser(UserEntity user) async {
    state = const AsyncLoading();
    try {
      final rowsAffected = await _repo.updateUser(user);
      if (rowsAffected == 0) {
        throw Exception('Failed to update user');
      }
      final current = [...state.value ?? <UserEntity>[]];
      final currentList = List<UserEntity>.from(current);
      final index = current.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        currentList[index] = user;
      }
      state = AsyncData<List<UserEntity>>(currentList);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    state = const AsyncLoading();
    try {
      final rowsAffected = await _repo.deleteUser(id);
      if (rowsAffected == 0) {
        throw Exception('Failed to delete user');
      }
      final current = [...state.value ?? <UserEntity>[]];
      final currentList = List<UserEntity>.from(current);
      final updatedList = currentList.where((u) => u.id != id).toList();
      state = AsyncData<List<UserEntity>>(updatedList);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}
