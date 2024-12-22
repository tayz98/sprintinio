import 'package:flutter_test/flutter_test.dart';
import 'package:sprintinio/models/room_user.dart';
import '../test_util/test_room_user_controller.dart';

void main() {
  group("RoomUser tests", () {
    test("RoomUser should be created correctly with all parameters", () {
      const String id = "id";
      const bool isHost = false;
      const bool isSpectator = false;

      final user = RoomUser(
        id: id,
        isHost: isHost,
        isSpectator: isSpectator,
      );

      expect(user.id, id);
      expect(user.isHost, isHost);
      expect(user.isSpectator, isSpectator);
    });

    test("RoomUser should be converted to JSON correctly", () {
      final RoomUser roomUser = TestRoomUserController.createDefaultRoomUser();
      final json = roomUser.toJson();
      expect(json["id"], roomUser.id);
      expect(json["isHost"], roomUser.isHost);
      expect(json["isSpectator"], roomUser.isSpectator);
    });

    test("RoomUser should be created from JSON correctly", () {
      final RoomUser roomUser = TestRoomUserController.createDefaultRoomUser();
      final json = roomUser.toJson();
      final newRoomUser = RoomUser.fromJson(json);
      expect(newRoomUser.id, roomUser.id);
      expect(newRoomUser.isHost, roomUser.isHost);
      expect(newRoomUser.isSpectator, roomUser.isSpectator);
    });

    test(
        "RoomUser should be equal to another RoomUser with the same parameters",
        () {
      final RoomUser roomUser = TestRoomUserController.createDefaultRoomUser();
      final RoomUser roomUser2 = TestRoomUserController.createDefaultRoomUser();
      expect(roomUser, roomUser2);
    });

    test("RoomUser should be correctly edited with copyWith", () {
      final RoomUser roomUser = TestRoomUserController.createDefaultRoomUser();
      final newRoomUser = roomUser.copyWith(isHost: true);
      expect(newRoomUser.isHost, true);
      expect(newRoomUser.id, roomUser.id);
      expect(newRoomUser.isSpectator, roomUser.isSpectator);
    });
  });
}
