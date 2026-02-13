import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/entities/message_entity.dart';
import 'package:velp_lite/core/repositories/message_repository.dart';
import 'package:velp_lite/core/services/message_db_helper.dart';
import 'package:velp_lite/core/view_models/message_view_model.dart';

final messageDbHelperProvider = Provider<MessageDbHelper>(
  (ref) => MessageDbHelper.instance,
);

final messageRepositoryProvider = Provider<MessageRepository>(
  (ref) => MessageRepository(db: ref.read(messageDbHelperProvider)),
);

final messageViewModelProvider =
    AsyncNotifierProvider<MessageViewModel, List<MessageEntity>>(
      () => MessageViewModel(),
    );
