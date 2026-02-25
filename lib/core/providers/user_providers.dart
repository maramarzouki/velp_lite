import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/features/auth/data/entity/user_entity.dart';
import 'package:velp_lite/features/auth/data/repository/user_repository.dart';
import 'package:velp_lite/core/services/user_db_helper.dart';
import 'package:velp_lite/features/auth/presentation/view_models/user_view_model.dart';

final userDbHelperProvider = Provider<UserDbHelper>(
  (ref) => UserDbHelper.instance,
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(db: ref.read(userDbHelperProvider)),
);

final userViewModelProvider = AsyncNotifierProvider<UserViewModel, UserEntity>(
  () {
    return UserViewModel();
  },
);
