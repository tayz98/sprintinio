import 'package:sprintinio/models/avatar.dart';

class AvatarManager {
  static List<Avatar> getAvatarList() {
    // Get list of Avatars from local assets
    final List<Avatar> avatarList = [];
    for (int i = 1; i <= 48; i++) {
      avatarList.add(
          Avatar(avatarId: "avatar$i", url: "assets/avatars/avatar$i.png"));
    }
    return avatarList;
  }

  static Avatar getDefaultAvatar() {
    return getAvatarList()[0];
  }
}
