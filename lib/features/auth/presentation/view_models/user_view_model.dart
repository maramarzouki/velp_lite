import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/features/auth/data/entity/user_entity.dart';
import 'package:velp_lite/core/providers/user_providers.dart';
import 'package:velp_lite/features/auth/data/repository/user_repository.dart';

class UserViewModel extends AsyncNotifier<UserEntity> {
  late final UserRepository _repo;

  @override
  Future<UserEntity> build() async {
    _repo = ref.read(userRepositoryProvider);
    return UserEntity(
      id: 0,
      firstName: '',
      lastName: '',
      email: '',
      password: '',
    );
  }

  Future<Map<String, dynamic>> createUser(UserEntity newUser) async {
    state = const AsyncLoading();
    try {
      final user = await _repo.createUser(newUser);
      debugPrint('newUser from view model: $user');
      // final createdList = [
      //   ...state.value ?? <UserEntity>[],
      //   newUser['user'] as UserEntity,
      // ];
      // state = AsyncData<List<UserEntity>>(createdList);
      return user;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return {'message': e.toString()};
    }
  }

  Future<UserEntity> loginUser(UserEntity user) async {
    state = const AsyncLoading();
    try {
      final userData = await _repo.loginUser(user);
      state = AsyncData(userData);
      return userData;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  // Future<UserEntity> getUser(int id) async {
  //   state = const AsyncLoading();
  //   try {
  //     final user = await _repo.getUser(id);
  //     state = AsyncData(user);
  //     return user;
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //     rethrow;
  //   }
  // }

  // Future<void> getUsers() async {
  //   state = const AsyncLoading();
  //   try {
  //     final users = await _repo.getUsers();

  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //     rethrow;
  //   }
  // }

  Future<void> updateUser(UserEntity user) async {
    state = const AsyncLoading();
    try {
      final rowsAffected = await _repo.updateUser(user);
      if (rowsAffected == 0) {
        throw Exception('Failed to update user');
      }
      // final current = [...state.value ?? <UserEntity>[]];
      // final currentList = List<UserEntity>.from(current);
      // final index = current.indexWhere((u) => u.id == user.id);
      // if (index != -1) {
      //   currentList[index] = user;
      // }
      // state = AsyncData<List<UserEntity>>(currentList);
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
      // final current = [...state.value ?? <UserEntity>[]];
      // final currentList = List<UserEntity>.from(current);
      // final updatedList = currentList.where((u) => u.id != id).toList();
      // state = AsyncData<List<UserEntity>>(updatedList);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}
