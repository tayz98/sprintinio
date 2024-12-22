import 'package:json_annotation/json_annotation.dart';
import 'package:sprintinio/models/create_tickets_permission.dart';
import 'package:sprintinio/models/room_user.dart';
import 'package:sprintinio/models/session.dart';
import 'package:sprintinio/models/voting_system.dart';

part 'room.g.dart';

/// A class representing a room in the application.
///
/// A room is a place where users can join and participate in a voting process during a [Session].
@JsonSerializable(explicitToJson: true)
class Room {
  /// The unique identifier of the room.
  final String id;

  /// The name of the room.
  final String name;

  /// The voting system used in the room.
  final VotingSystem votingSystem;

  // The short code of the room a user can type in his interface to join the room.
  final String shortCode;

  /// The permission to create tickets in the room.
  final ManageIssuesPermission manageIssuesPermission;

  /// The list of all users in the room.
  List<RoomUser> roomUsers;

  /// The session that is currently active in the room.
  final Session? session;

  /// A flag indicating if the room is private.
  final bool isPrivate;

  final List<String>? invitedUserEmails;

  Room({
    required this.id,
    required this.name,
    required this.votingSystem,
    required this.manageIssuesPermission,
    required this.shortCode,
    required this.roomUsers,
    required this.session,
    required this.isPrivate,
    required this.invitedUserEmails,
  });

  void destroy() {
    // destroy room
  }

  Room copyWith({
    String? id,
    String? name,
    VotingSystem? votingSystem,
    String? shortCode,
    List<RoomUser>? roomUsers,
    ManageIssuesPermission? manageIssuesPermission,
    Session? session,
    bool? isPrivate,
    List<String>? invitedUserEmails,
  }) {
    return Room(
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
    );
  }

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
