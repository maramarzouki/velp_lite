import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/entities/vet_entity.dart';
import 'package:velp_lite/core/repositories/vet_repository.dart';
import 'package:velp_lite/core/services/vet_db_helper.dart';
import 'package:velp_lite/core/view_models/vet_view_model.dart';

final vetDbHelperProvider = Provider<VetDbHelper>(
  (ref) => VetDbHelper.instance,
);

final vetRepositoryProvider = Provider<VetRepository>(
  (ref) => VetRepository(db: ref.read(vetDbHelperProvider)),
);

final vetViewModelProvider =
    AsyncNotifierProvider<VetViewModel, List<VetEntity>>(() {
      return VetViewModel();
    });

final vetInfoProvider = FutureProvider.autoDispose.family<VetEntity, int>((
  ref,
  vetID,
) {
  final notifier = ref.read(vetViewModelProvider.notifier);
  return notifier.getVet(vetID);
});
