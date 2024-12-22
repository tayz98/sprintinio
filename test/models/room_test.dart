import 'package:sprintinio/models/create_tickets_permission.dart';
import 'package:sprintinio/models/room.dart';
import 'package:sprintinio/models/room_user.dart';
import 'package:sprintinio/models/session.dart';
import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/models/votingtypes/fibonacci.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_util/test_room_controller.dart';
import '../test_util/test_session_controller.dart';

void main() {
  group("Room tests", () {
    test(
        "Room should be created correctly with all parameters and default session",
        () {
      const String id = "id";
      const String name = "name";
      final VotingSystem votingSystem =
          VotingSystem(name: "Fibonacci", votingType: Fibonacci());
      const String shortCode = "code";
      const ManageIssuesPermission manageIssuesPermission =
          ManageIssuesPermission.everyone;
      final List<RoomUser> roomUsers = [];
      final Session session = TestSessionController.createDefaultSession();
      const bool isPrivate = false;
      final List<String> invitedUserEmails = [];

      final room = Room(
        id: id,
        name: name,
        votingSystem: votingSystem,
        manageIssuesPermission: manageIssuesPermission,
        shortCode: shortCode,
        roomUsers: roomUsers,
        session: session,
        isPrivate: isPrivate,
        invitedUserEmails: invitedUserEmails,
      );

      expect(room.id, id);
      expect(room.name, name);
      expect(room.votingSystem, votingSystem);
      expect(room.shortCode, shortCode);
      expect(room.manageIssuesPermission, manageIssuesPermission);
      expect(room.roomUsers, roomUsers);
      expect(room.session, session);
    });

    test(
        "Room should be created correctly with all parameters and empty session",
        () {
      const String id = "id";
      const String name = "name";
      final VotingSystem votingSystem =
          VotingSystem(name: "Fibonacci", votingType: Fibonacci());
      const String shortCode = "code";
      const ManageIssuesPermission manageIssuesPermission =
          ManageIssuesPermission.everyone;
      final List<RoomUser> roomUsers = [];
      const bool isPrivate = false;
      final List<String> invitedUserEmails = [];

      final room = Room(
        id: id,
        name: name,
        votingSystem: votingSystem,
        manageIssuesPermission: manageIssuesPermission,
        shortCode: shortCode,
        roomUsers: roomUsers,
        session: null,
        isPrivate: isPrivate,
        invitedUserEmails: invitedUserEmails,
      );

      expect(room.id, id);
      expect(room.name, name);
      expect(room.votingSystem, votingSystem);
      expect(room.shortCode, shortCode);
      expect(room.manageIssuesPermission, manageIssuesPermission);
      expect(room.roomUsers, roomUsers);
      expect(room.session, null);
    });

    test("Room should be converted to JSON correctly", () {
      final Room room = TestRoomController.createDefaultRoom();
      final json = room.toJson();
      expect(json["id"], room.id);
      expect(json["name"], room.name);
      expect(json["votingSystem"], room.votingSystem.toJson());
      expect(json["shortCode"], room.shortCode);
      expect(
          json["manageIssuesPermission"], room.manageIssuesPermission.string);
      expect(json["roomUsers"], room.roomUsers);
      expect(json["session"], room.session!.toJson());
    });

    test("Room should be created correctly from JSON", () {
      final Room room = TestRoomController.createDefaultRoom();
      final json = room.toJson();
      final jsonRoom = Room.fromJson(json);
      expect(jsonRoom.id, room.id);
      expect(jsonRoom.name, room.name);
      expect(jsonRoom.votingSystem, room.votingSystem);
      expect(jsonRoom.shortCode, room.shortCode);
      expect(jsonRoom.manageIssuesPermission, room.manageIssuesPermission);
      expect(jsonRoom.roomUsers, room.roomUsers);
      expect(jsonRoom.session, room.session);
    });

    test("Room should not be equal to another Room with the same values", () {
      final room1 = TestRoomController.createDefaultRoom();
      final room2 = TestRoomController.createDefaultRoom();
      expect(room1 != room2, true);
    });

    test("Room should be correctly edited with copyWith", () {
      final room = TestRoomController.createDefaultRoom();
      const String newId = "newId";
      const String newName = "newName";
      final VotingSystem newVotingSystem =
          VotingSystem(name: "Fibonacci", votingType: Fibonacci());
      const String newShortCode = "newCode";
      const ManageIssuesPermission newManageIssuesPermission =
          ManageIssuesPermission.onlyHost;
      final List<RoomUser> newRoomUsers = [];
      final Session newSession = TestSessionController.createDefaultSession();
      final newRoom = room.copyWith(
        id: newId,
        name: newName,
        votingSystem: newVotingSystem,
        shortCode: newShortCode,
        roomUsers: newRoomUsers,
        manageIssuesPermission: newManageIssuesPermission,
        session: newSession,
      );
      expect(newRoom.id, newId);
      expect(newRoom.name, newName);
      expect(newRoom.votingSystem, newVotingSystem);
      expect(newRoom.shortCode, newShortCode);
      expect(newRoom.manageIssuesPermission, newManageIssuesPermission);
      expect(newRoom.roomUsers, newRoomUsers);
      expect(newRoom.session, newSession);
    });
  });
}
