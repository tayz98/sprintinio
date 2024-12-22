import 'package:sprintinio/models/create_tickets_permission.dart';
import 'package:sprintinio/models/room.dart';
import 'package:sprintinio/models/room_user.dart';
import 'package:sprintinio/models/session.dart';
import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/models/votingtypes/fibonacci.dart';

import 'test_session_controller.dart';

class TestRoomController {
  static const String defaultId = 'id';
  static const String defaultName = 'room';
  static const String defaultShortCode = 'code';
  static final VotingSystem defaultVotingSystem = VotingSystem(
    name: 'Fibonacci',
    votingType: Fibonacci(),
  );
  static const ManageIssuesPermission defaultManageIssuesPermission =
      ManageIssuesPermission.everyone;
  static final List<RoomUser> defaultRoomUsers = [];
  static final Session defaultSession =
      TestSessionController.createDefaultSession();
  static const bool defaultIsPrivate = false;
  static const List<String> defaultInvitedUserEmails = [];

  static Room createDefaultRoom() {
    return Room(
      id: defaultId,
      name: defaultName,
      votingSystem: defaultVotingSystem,
      manageIssuesPermission: defaultManageIssuesPermission,
      shortCode: defaultShortCode,
      roomUsers: defaultRoomUsers,
      session: defaultSession,
      isPrivate: defaultIsPrivate,
      invitedUserEmails: defaultInvitedUserEmails,
    );
  }
}
