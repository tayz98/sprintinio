import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_room_id_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentRoomId extends _$CurrentRoomId {
  @override
  String? build() {
    return null;
  }

  void setCurrentRoomId(String roomId) {
    state = roomId;
  }

  void clearCurrentRoomId() {
    state = null;
  }
}
