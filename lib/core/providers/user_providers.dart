import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/entities/user_entity.dart';
import 'package:velp_lite/core/repositories/user_repository.dart';
import 'package:velp_lite/core/services/user_db_helper.dart';
import 'package:velp_lite/core/view_models/user_view_model.dart';

final userDbHelperProvider = Provider<UserDbHelper>(
  (ref) => UserDbHelper.instance,
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(db: ref.read(userDbHelperProvider)),
);

final userViewModelProvider =
    AsyncNotifierProvider<UserViewModel, List<UserEntity>>(() {
      return UserViewModel();
    });
