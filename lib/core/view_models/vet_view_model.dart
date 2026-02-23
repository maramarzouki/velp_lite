import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/entities/vet_entity.dart';
import 'package:velp_lite/core/providers/vet_providers.dart';
import 'package:velp_lite/core/repositories/vet_repository.dart';

class VetViewModel extends AsyncNotifier<List<VetEntity>> {
  late final VetRepository _repo;

  @override
  Future<List<VetEntity>> build() async {
    _repo = ref.read(vetRepositoryProvider);
    return await _repo.getVets();
  }

  Future<List<VetEntity>> getVets() async {
    state = const AsyncLoading();
    try {
      final vets = await _repo.getVets();
      state = AsyncData(vets);
      return vets;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<VetEntity> getVet(int id) async {
    state = const AsyncLoading();
    try {
      final vet = await _repo.getVet(id);
      return vet;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

}