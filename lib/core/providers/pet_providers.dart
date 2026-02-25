import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/features/home/data/entity/pet_entity.dart';
import 'package:velp_lite/core/services/pet_db_helper.dart';
import 'package:velp_lite/features/home/data/repository/pet_repository.dart';
import 'package:velp_lite/features/home/presentation/view_models/pet_view_model.dart';

final petDbHelperProvider = Provider<PetDbHelper>(
  (ref) => PetDbHelper.instance,
);

final petRepositoryProvider = Provider<PetRepository>((ref) {
  final db = ref.read(petDbHelperProvider);
  return PetRepository(db: db);
});

final petViewModelProvider =
    AsyncNotifierProvider.family<PetViewModel, List<PetEntity>, int>(
  (ownerId) => PetViewModel(ownerId: ownerId),
);
