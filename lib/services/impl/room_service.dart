import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/models/session.dart';
import 'package:sprintinio/services/impl/firebase_user_service.dart';
import 'package:sprintinio/models/room.dart';
import 'package:sprintinio/models/room_user.dart';
import 'package:sprintinio/providers/providers.dart';
import 'package:sprintinio/services/firestore_service_base.dart';
import 'package:sprintinio/util/misc.dart';

/// Provider for the [RoomService].
final roomServiceProvider = Provider<RoomService>((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  final firebaseUserService = ref.read(firebaseUserServiceProvider);
  return RoomService(firestore, firebaseUserService);
});

/// Service for managing rooms in Firestore.
class RoomService extends FirestoreServiceBase<Room> {
  RoomService(firestore, this.firebaseUserService)
      : super(firestore, 'rooms', (data) => Room.fromJson(data),
            (room) => room.toJson());

  final FirebaseUserService firebaseUserService;

  /// Adds a new room to Firestore.
  ///
  /// Returns the room with the generated id from Firestore.
  Future<Room> addItem(Room item) async {
    final String newRoomDocId = collection.doc().id;
    final String shortCodeForRoom = UtilMisc.generateShortCode(newRoomDocId);
    final Room newRoom = item.copyWith(
        id: newRoomDocId,
        shortCode: shortCodeForRoom,
        invitedUserEmails: item.invitedUserEmails);
    await collection.doc(newRoomDocId).set(newRoom);
    return newRoom;
  }

  // todo: check if legacy
  /// Stream of a single [RoomUser] by [Room] id and [RoomUser] id.
  Stream<RoomUser?> streamRoomUserById(String roomId, String userId) {
    return collection.doc(roomId).snapshots().map((snapshot) {
      for (var roomUser in snapshot.data()!.roomUsers) {
        if (roomUser.id == userId) {
          return roomUser;
        }
      }
      return null;
    });
  }

  /// Find the [Room] by its short code.
  Future<Room?> getRoomByShortCode(String shortCode) async {
    final snapshot = await collection
        .where('shortCode', isEqualTo: shortCode)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }

  /// Join a [RoomUser] to the [Room] by its id.
  Future<bool> joinRoomUser(
      {required String roomId, required RoomUser roomUser}) async {
    final roomDoc = await collection.doc(roomId).get();
    if (roomDoc.exists) {
      final roomData = roomDoc.data()!;
      // Check if there are not users in the room currently
      if (roomData.roomUsers.isEmpty) {
        // Set the joining user host
        roomUser.isHost = true;
      }

      roomData.roomUsers.add(roomUser);
      await collection.doc(roomId).update(roomData.toJson());

      return true;
    } else {
      throw Exception('Room not found');
    }
  }

  /// Update a [RoomUser] in the [Room] by its id.
  Future<void> updateRoomUser(String roomId, RoomUser roomUser) async {
    final roomDoc = await collection.doc(roomId).get();
    if (roomDoc.exists) {
      final roomData = roomDoc.data()!;
      final index = roomData.roomUsers.indexWhere((ru) => ru.id == roomUser.id);

      if (index != -1) {
        roomData.roomUsers[index] = roomUser;
        await collection.doc(roomId).update(roomData.toJson());
      }
    }
  }

  /// Update a [Session] in the [Room] by its id.
  Future<void> updateSession(String roomId, Session session) async {
    await collection.doc(roomId).update({'session': session.toJson()});
  }

  /// Update the [roomUsers] array in a [Room] by its id.
  Future<void> updateRoomUsers(
      String roomId, List<RoomUser> updatedRoomUsers) async {
    final roomUsersJson =
        updatedRoomUsers.map((user) => user.copyWith().toJson()).toList();
    await collection.doc(roomId).update({'roomUsers': roomUsersJson});
  }

  Future<void> updateVote(String roomId, String userId, int voteValue) async {
    await collection.doc(roomId).set(
        {
          'session': {
            'votingProcess': {
              'votes': {userId: voteValue}
            }
          }
        } as Room,
        SetOptions(merge: true));
  }

  /// Adding an email directly into the whiteList of a room via the service
  /// Used when creating a private room to add the host
  Future<void> addInvitedUserEmail(String roomId, String email) async {
    final roomDoc = await collection.doc(roomId).get();
    if (roomDoc.exists) {
      final roomData = roomDoc.data()!;
      List<String>? invitedEmails = roomData.invitedUserEmails;
      invitedEmails ??= [];
      invitedEmails.add(email);

      await collection.doc(roomId).update({'invitedUserEmails': invitedEmails});
    }
  }
}
