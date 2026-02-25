import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/features/chat/data/entity/chat_room_entity.dart';
import 'package:velp_lite/features/chat/data/repository/chat_room_repository.dart';
import 'package:velp_lite/core/services/chat_room_db_helper.dart';
import 'package:velp_lite/features/chat/presentation/view_models/chat_room_view_model.dart';

final chatRoomDbHelperProvider = Provider<ChatRoomDbHelper>(
  (ref) => ChatRoomDbHelper.instance,
);

final chatRoomRepositoryProvider = Provider<ChatRoomRepository>((ref) {
  final db = ref.watch(chatRoomDbHelperProvider);
  return ChatRoomRepository(db: db);
});

final chatRoomViewModelProvider =
    AsyncNotifierProvider.family<ChatRoomViewModel, List<ChatRoomEntity>, int>(
      ChatRoomViewModel.new,
    );
