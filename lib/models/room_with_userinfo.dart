import 'package:sprintinio/models/room.dart';
import 'package:sprintinio/models/room_user.dart';
import 'package:sprintinio/models/session.dart';
import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/models/combined_user.dart';
import 'package:sprintinio/models/create_tickets_permission.dart';

class RoomWithUserinfo extends Room {
  final List<CombinedUser> users;

  RoomWithUserinfo({required Room room, required this.users})
      : super(
            id: room.id,
            name: room.name,
            votingSystem: room.votingSystem,
            manageIssuesPermission: room.manageIssuesPermission,
            shortCode: room.shortCode,
            roomUsers: room.roomUsers,
            session: room.session,
            isPrivate: room.isPrivate,
            invitedUserEmails: room.invitedUserEmails);

  RoomWithUserinfo copyWithRoomUsers({
    String? id,
    String? name,
    VotingSystem? votingSystem,
    String? shortCode,
    List<RoomUser>? roomUsers,
    ManageIssuesPermission? manageIssuesPermission,
    Session? session,
    bool? isPrivate,
    List<String>? invitedUserEmails,
    List<CombinedUser>? users,
  }) {
    return RoomWithUserinfo(
      room: Room(
        id: id ?? this.id,
        name: name ?? this.name,
        votingSystem: votingSystem ?? this.votingSystem,
        manageIssuesPermission:
            manageIssuesPermission ?? this.manageIssuesPermission,
        shortCode: shortCode ?? this.shortCode,
        roomUsers: roomUsers ?? this.roomUsers,
        session: session ?? this.session,
        isPrivate: isPrivate ?? this.isPrivate,
        invitedUserEmails: invitedUserEmails ?? this.invitedUserEmails,
      ),
      users: users ?? this.users,
    );
  }
}
