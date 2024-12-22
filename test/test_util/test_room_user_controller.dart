import 'package:sprintinio/models/firebase_user.dart';
import 'package:sprintinio/models/room_user.dart';

import 'test_firebase_user_controller.dart';

class TestRoomUserController {
  static const String defaultId = 'id';
  static const bool defaultIsHost = false;
  static const bool defaultIsSpectator = false;
  static final FirebaseUser defaultFirebaseUser =
      TestFirebaseUserController.createDefaultFirebaseUser();

  static RoomUser createDefaultRoomUser() {
    return RoomUser(
      id: defaultId,
      isHost: defaultIsHost,
      isSpectator: defaultIsSpectator,
    );
  }
}
