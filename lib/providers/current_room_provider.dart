import 'dart:async';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sprintinio/app_config.dart';
import 'package:sprintinio/models/combined_user.dart';
import 'package:sprintinio/models/firebase_user.dart';
import 'package:sprintinio/models/room_with_userinfo.dart';
import 'package:sprintinio/providers/providers.dart';
import 'package:sprintinio/providers/room_voting_provider.dart';
import 'package:sprintinio/services/impl/firebase_user_service.dart';
import 'package:sprintinio/services/impl/room_service.dart';
import 'package:sprintinio/models/room.dart';
import 'package:sprintinio/providers/current_room_id_provider.dart';

part 'current_room_provider.g.dart';

@riverpod
class CurrentRoom extends _$CurrentRoom {
  String? currentRoomId;
  StreamSubscription? _roomStreamSubscription;

  //*
  // The build method is called whenever the provider is read and rebuilds when the currentRoomId changes
  //*
  @override
  Future<RoomWithUserinfo?> build() async {
    currentRoomId = ref.watch(currentRoomIdProvider);
    Logger().d("Running build method in CurrentRoomProvider");

    if (currentRoomId == null) {
      await _unsubscribeFromRoom();
      return null;
    }
    return _subscribeToRoom(currentRoomId!);
  }

  void dispose() {
    _unsubscribeFromRoom();
  }

  //*
  // A: Subscription handler functions for the current room provider
  //*

  // Subscribe to a room stream
  Future<RoomWithUserinfo?> _subscribeToRoom(String roomId) async {
    Logger().d("Subscribing to room stream");
    await _unsubscribeFromRoom();
    final roomStream = ref.read(roomServiceProvider).streamItemById(roomId);
    _roomStreamSubscription = roomStream.listen((room) async {
      Logger().d("✅ Room Update");
      // Check if the room is empty
      if (room == null) {
        state = const AsyncValue.data(null);
        return;
      }

      state = const AsyncValue.loading();
      try {
        final updatedRoomWithUserInfo =
            await _fetchUpdatedRoomWithUserInfo(room);
        state = AsyncValue.data(updatedRoomWithUserInfo);
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
      await ref.read(roomVotingProvider.notifier).handleVotingState();
    }, onError: (error, stackTrace) {
      state = AsyncValue.error(error,
          stackTrace); // Pass the error and stackTrace to the AsyncValue.error method
    });
    return null;
  }

  // Unsubscribe from a room stream
  Future<RoomWithUserinfo?> _unsubscribeFromRoom() async {
    Logger().d("Unsubscribing from room stream");
    await _roomStreamSubscription?.cancel();
    _roomStreamSubscription = null;
    return null;
  }

  Future<RoomWithUserinfo> _fetchUpdatedRoomWithUserInfo(Room newRoom) async {
    // Get the old room data
    final RoomWithUserinfo? oldRoom = state.value;
    // Checks if the room users have changed
    if (oldRoom != null &&
        newRoom.roomUsers.length == oldRoom.roomUsers.length &&
        newRoom.roomUsers.every((roomUser) => oldRoom.roomUsers.any(
            (oldRoomUser) =>
                oldRoomUser.id == roomUser.id &&
                oldRoomUser.lastUpdated == roomUser.lastUpdated))) {
      Logger()
          .d("💤 Room users have not changed and do not need to be updated.");
      return RoomWithUserinfo(room: newRoom, users: oldRoom.users);
    }

    Logger().d("🔄 Room users have changed and need to be updated.");
    // Get the current user id from the firebase auth provider
    final String? currentUserId =
        ref.read(firebaseAuthProvider).currentUser?.uid;

    // Get the firebase user service
    final firebaseUserService = ref.read(firebaseUserServiceProvider);

    final List<CombinedUser> users = await Future.wait(
      newRoom.roomUsers.map((roomUser) async {
        // Fetch the latest FirebaseUser data for each user
        final FirebaseUser? firebaseUser =
            await firebaseUserService.getItemById(roomUser.id);
        if (firebaseUser == null) {
          throw Exception('Failed to fetch user ${roomUser.id}');
        }
        Logger().d(
            "Fetched updated user data for ${firebaseUser.username} with avatar ${firebaseUser.avatar.avatarId}");
        return CombinedUser(
            roomUser: roomUser,
            firebaseUser: firebaseUser,
            isCurrentUser:
                currentUserId != null && currentUserId == firebaseUser.id);
      }),
    );

    return RoomWithUserinfo(room: newRoom, users: users);
  }

  //*
  // Public util functions

  /// generate a link for the room
  String generateRoomLink() {
    // check if room is empty
    if (state.value == null) {
      return '';
    }
    return '${AppConfig.baseUrl}/join/${state.value?.id}';
  }
}
