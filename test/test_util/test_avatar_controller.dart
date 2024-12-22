import 'package:sprintinio/models/avatar.dart';

class TestAvatarController {
  static const String defaultAvatarId = "id";
  static const String defaultUrl = "url";

  static Avatar createDefaultAvatar() {
    return Avatar(avatarId: defaultAvatarId, url: defaultUrl);
  }
}
