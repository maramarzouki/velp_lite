import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/entities/rdv_entity.dart';
import 'package:velp_lite/core/services/rdv_db_helper.dart';
import 'package:velp_lite/features/rdv/data/repository/rdv_repository.dart';
import 'package:velp_lite/features/rdv/presentation/view_models/rdv_view_model.dart';

final rdvDbHelperProvider = Provider<RdvDbHelper>(
  (ref) => RdvDbHelper.instance,
);

final rdvRepositoryProvider = Provider<RdvRepository>((ref) {
  final db = ref.read(rdvDbHelperProvider);
  return RdvRepository(db: db);
});

final rdvViewModelProvider =
    AsyncNotifierProvider<RdvViewModel, List<RdvEntity>>(() => RdvViewModel());
