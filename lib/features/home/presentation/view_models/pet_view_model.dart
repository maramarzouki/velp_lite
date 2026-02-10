import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/entities/pet_entity.dart';
import 'package:velp_lite/core/providers/pet_providers.dart';
import 'package:velp_lite/features/home/data/repository/pet_repository.dart';

class PetViewModel extends AsyncNotifier<List<PetEntity>> {
  late final PetRepository repo;

  @override
  Future<List<PetEntity>> build() async {
    repo = await ref.read(petRepositoryProvider);
    return await repo.getPets();
  }

  Future<void> addPet(PetEntity pet) async {
    state = const AsyncLoading();
    try {
      final newPet = await repo.addPet(pet);
      final createdList = [...state.value ?? <PetEntity>[], newPet];
      state = AsyncData<List<PetEntity>>(createdList);
    } catch (e) {
      debugPrint('Error adding pet: $e');
      state = AsyncError(e, StackTrace.current);
    }
  }

  // Future<PetEntity> getPet(int id) async {
  //   try {
  //     return await repo.getPet(id);
  //   } catch (e, stackTrace) {
  //     debugPrint('Error getting pet: $e');
  //     Error.throwWithStackTrace(e, stackTrace);
  //   }
  // }

  Future<void> updatePet(PetEntity pet) async {
    state = const AsyncLoading();
    try {
      final rowsAffected = await repo.updatePet(pet);
      if (rowsAffected == 0) {
        throw Exception('Failed to update pet');
      }

      final current = [...state.value ?? <PetEntity>[]];
      final currentList = List<PetEntity>.from(current);
      final index = current.indexWhere((p) => p.id == pet.id);
      if (index != -1) {
        currentList[index] = pet;
      }
      state = AsyncData<List<PetEntity>>(currentList);
    } catch (e) {
      debugPrint('Error updating pet: $e');
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> deletePet(int id) async {
    state = const AsyncLoading();
    try {
      final rowsAffected = await repo.deletePet(id);
      if (rowsAffected == 0) {
        throw Exception('No pet deleted (ID $id not found?)');
      }

      final current = [...state.value ?? <PetEntity>[]];
      final currentList = List<PetEntity>.from(current);
      final updatedList = currentList.where((p) => p.id != id).toList();
      state = AsyncData<List<PetEntity>>(updatedList);
    } catch (e) {
      debugPrint('Error deleting pet: $e');
      state = AsyncError(e, StackTrace.current);
    }
  }
}
