import 'package:sprintinio/models/avatar.dart';
import 'package:sprintinio/models/firebase_user.dart';

import 'test_avatar_controller.dart';

class TestFirebaseUserController {
  static const String defaultId = 'id';
  static const String defaultUsername = 'username';
  static const bool defaultIsAuthenticated = true;
  static const String defaultAuthMethod = 'anonymous';
  static final DateTime defaultCreationTime = DateTime.now();
  static final Avatar defaultAvatar =
      TestAvatarController.createDefaultAvatar();

  static FirebaseUser createDefaultFirebaseUser() {
    return FirebaseUser(
      id: defaultId,
      username: defaultUsername,
      avatar: defaultAvatar,
      creationTime: defaultCreationTime,
    );
  }
}
