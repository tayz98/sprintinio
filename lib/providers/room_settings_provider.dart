import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sprintinio/models/create_tickets_permission.dart';
import 'package:sprintinio/models/room.dart';
import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/services/impl/room_service.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/models/room_user.dart';
import 'package:sprintinio/models/room_with_userinfo.dart';

part 'room_settings_provider.g.dart';

@riverpod
class RoomSettings extends _$RoomSettings {
  @override
  Future<RoomWithUserinfo?> build() async {
    return ref.watch(currentRoomProvider.future);
  }

  //*
  // Public user action functions to update the room settings
  //*

  // Room Settings
  Future<void> updateRoomSettings(
      String name,
      bool isPrivate,
      ManageIssuesPermission manageIssuesPermission,
      VotingSystem votingSystem) async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null) {
      return;
    }

    // Copy the room and update the settings
    final updatedRoom = currentRoom.copyWith(
      name: name,
      isPrivate: isPrivate,
      manageIssuesPermission: manageIssuesPermission,
      votingSystem: votingSystem,
    );

    // Save the updated room to Firestore
    await ref.read(roomServiceProvider).updateItem(updatedRoom.id, updatedRoom);
  }

  Future<void> updateInvitedUserEmails(List<String> invitedUserEmails) async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null) {
      return;
    }

    // Copy the room and update the invited user emails
    final updatedRoom = currentRoom.copyWith(
      invitedUserEmails: invitedUserEmails,
    );

    // Save the updated room to Firestore
    await ref.read(roomServiceProvider).updateItem(updatedRoom.id, updatedRoom);
  }

  // Change the host of the room to a new user
  Future<void> changeHost({RoomUser? newHost, RoomUser? leavingHost}) async {
    final currentRoom = ref.read(currentRoomProvider).value;

    // Check if the room is empty
    if (currentRoom == null) {
      return;
    }

    if (newHost != null) {
      final List<RoomUser> roomUsers = currentRoom.roomUsers;
      removeHostFromRoomUsers(roomUsers);
      final newHostIndex =
          roomUsers.indexWhere((roomUser) => roomUser.id == newHost.id);
      if (newHostIndex == -1) {
        throw Exception('New host not found in room users');
      }
      roomUsers[newHostIndex] = roomUsers[newHostIndex].copyWith(isHost: true);
      await ref
          .read(roomServiceProvider)
          .updateRoomUsers(currentRoom.id, roomUsers);
    } else {
      if (currentRoom.roomUsers.length == 1) {
        return;
      }
      final List<RoomUser> roomUsers = currentRoom.roomUsers;
      removeHostFromRoomUsers(roomUsers);
      for (RoomUser user in roomUsers) {
        if (user.id != leavingHost!.id) {
          roomUsers[roomUsers.indexOf(user)] =
              user.copyWith(isHost: true, isUpdated: true);
          break;
        }
      }
      await ref
          .read(roomServiceProvider)
          .updateRoomUsers(currentRoom.id, roomUsers);
    }
  }

  // Remove the host status from all room users
  void removeHostFromRoomUsers(List<RoomUser> roomUsers) {
    for (RoomUser user in roomUsers) {
      user.isHost = false;
    }
  }

  Future<Room?> getRoomById(String roomId) async {
    return await ref.read(roomServiceProvider).getItemById(roomId);
  }

  Future<Room?> getRoomByShortCode(String shortCode) async {
    return await ref.read(roomServiceProvider).getRoomByShortCode(shortCode);
  }

  Future<void> addInvitedUserEmail(String roomId, String email) async {
    await ref.read(roomServiceProvider).addInvitedUserEmail(roomId, email);
  }
}
