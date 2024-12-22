import 'package:sprintinio/models/room_user.dart';
import 'firebase_user.dart';

class CombinedUser {
  final RoomUser roomUser;
  final FirebaseUser firebaseUser;
  final bool isCurrentUser;

  CombinedUser(
      {required this.roomUser,
      required this.firebaseUser,
      required this.isCurrentUser});
}
