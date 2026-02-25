import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/features/rdv/data/entity/rdv_entity.dart';
import 'package:velp_lite/features/rdv/presentation/view_models/rdv_providers.dart';
import 'package:velp_lite/features/rdv/data/repository/rdv_repository.dart';

class RdvViewModel extends AsyncNotifier<List<RdvEntity>> {
  late final RdvRepository repo;
  final int petID;

  RdvViewModel({required this.petID});

  @override
  Future<List<RdvEntity>> build() async {
    debugPrint('Building RdvViewModel');
    repo = ref.read(rdvRepositoryProvider);
    debugPrint('RdvViewModel built');
    return await repo.getRdvs(petID);
  }

  Future<RdvEntity> addRdv(RdvEntity rdv) async {
    state = const AsyncLoading();
    try {
      final newRDV = await repo.createRdv(rdv);
      final createdList = [...state.value ?? <RdvEntity>[], newRDV];
      state = AsyncData<List<RdvEntity>>(createdList);
      return newRDV;
    } catch (e) {
      debugPrint('Error adding rdv: $e');
      state = AsyncError(e, StackTrace.current);
      throw Exception('Error adding rdv: $e');
    }
  }

  Future<List<RdvEntity>> getRdvByAnimalId(int id) async {
    try {
      return await repo.getRdvByAnimalId(id);
    } catch (e) {
      debugPrint('Error getting rdv: $e');
      throw Exception('Error getting rdv: $e');
    }
  }

  Future<void> updateRdv(RdvEntity rdv) async {
    try {
      final rowsAffected = await repo.updateRdv(rdv);
      if (rowsAffected == 0) {
        throw Exception('Failed to update rdv');
      }

      final currentList = [...state.value ?? <RdvEntity>[]];
      final index = currentList.indexWhere((p) => p.id == rdv.id);
      if (index != -1) {
        currentList[index] = rdv;
        state = AsyncData<List<RdvEntity>>(currentList);
      }
    } catch (e) {
      debugPrint('Error updating rdv: $e');
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> deleteRdv(int id) async {
    state = const AsyncLoading();
    try {
      final rowsAffected = await repo.deleteRdv(id);
      if (rowsAffected == 0) {
        throw Exception('No rdv deleted (ID $id not found?)');
      }

      final currentList = [...state.value ?? <RdvEntity>[]];
      final updatedList = currentList.where((p) => p.id != id).toList();
      state = AsyncData<List<RdvEntity>>(updatedList);
    } catch (e) {
      debugPrint('Error deleting rdv: $e');
      state = AsyncError(e, StackTrace.current);
    }
  }
}
