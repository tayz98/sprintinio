import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sprintinio/models/avatar.dart';
import 'package:sprintinio/models/room.dart';
import 'package:sprintinio/models/room_user.dart';
import 'package:sprintinio/models/room_with_userinfo.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/providers/room_settings_provider.dart';
import 'package:sprintinio/services/impl/room_service.dart';
import 'package:sprintinio/providers/current_room_provider.dart';

part 'room_users_provider.g.dart';

@riverpod
class RoomUsers extends _$RoomUsers {
  @override
  Future<RoomWithUserinfo?> build() async {
    return ref.watch(currentRoomProvider.future);
  }

  //*
  // Public user action functions to manage its state in the room
  //*

  // Join room
  Future<bool> joinRoom(String roomId, RoomUser roomUser) async {
    return await ref
        .read(roomServiceProvider)
        .joinRoomUser(roomId: roomId, roomUser: roomUser);
  }

  // Make the currentUser leave the room in the roomUsers
  Future<void> leaveRoom() async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null) {
      return;
    }

    // Get the current user
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) {
      return;
    }

    final leavingUser = currentRoom.roomUsers
        .firstWhere((roomUser) => roomUser.id == currentUser.id);

    if (leavingUser.isHost) {
      ref
          .read(roomSettingsProvider.notifier)
          .changeHost(leavingHost: leavingUser);
    }

    // Copy the room and remove the current user from the roomUsers
    final Room updatedRoom = currentRoom.copyWith(
      roomUsers: currentRoom.roomUsers
          .where((roomUser) => roomUser.id != currentUser.id)
          .toList(),
    );

    // Save the updated room to Firestore
    await ref.read(roomServiceProvider).updateItem(updatedRoom.id, updatedRoom);
  }

  // Let the user change its firebase user from within the room and update the roomUsers to trigger a rebuild for all clients (subscribers)
  Future<void> updateCurrentUserFromRoom(
      String username, Avatar avatar, bool isSpectating) async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null) {
      return;
    }

    // Get the current user
    final currentUserNotifier = ref.read(currentUserProvider.notifier);
    final currentUser = ref.read(currentUserProvider).value;

    // Check if the current user is in the room
    if (currentUser == null ||
        currentRoom.roomUsers
            .where((roomUser) => roomUser.id == currentUser.id)
            .isEmpty) {
      return;
    }

    // Call the createOrUpdateCurrentUser method from the currentUserNotifier
    await currentUserNotifier.createOrUpdateCurrentUser(
        userId: currentUser.id, username: username, avatar: avatar);

    // Make a simple copy of the roomUsers and update the room users to trigger a rebuild for all clients (subscribers)
    final updatedRoomUsers = currentRoom.roomUsers.map((roomUser) {
      if (roomUser.id == currentUser.id) {
        return roomUser.copyWith(isSpectator: isSpectating, isUpdated: true);
      }
      return roomUser;
    }).toList();
    await ref
        .read(roomServiceProvider)
        .updateRoomUsers(currentRoom.id, updatedRoomUsers);
  }
}
