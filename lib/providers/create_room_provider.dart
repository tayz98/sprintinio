import 'package:sprintinio/models/create_tickets_permission.dart';
import 'package:sprintinio/models/session.dart';
import 'package:sprintinio/models/session_state.dart';
import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/models/room.dart';
import 'package:sprintinio/services/impl/room_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_room_provider.g.dart';

@Riverpod(keepAlive: true)
class CreateRoom extends _$CreateRoom {
  late final RoomService roomService = ref.read(roomServiceProvider);

  @override
  Room? build() {
    return null;
  }

  /// Initializes the room being created with the given parameters.
  void initializeRoom({
    required String id,
    required String name,
    required VotingSystem votingSystem,
    required ManageIssuesPermission manageIssuesPermission,
    bool isPrivate = false,
    List<String>? invitedUserEmails,
  }) {
    final newRoom = Room(
      id: id,
      name: name,
      votingSystem: votingSystem,
      manageIssuesPermission: manageIssuesPermission, // Default value
      shortCode: '', // Default value
      roomUsers: [], // Default value
      session: Session(
        currentState: SessionState.pending,
        tickets: [],
      ), // Default value = empty session
      isPrivate: isPrivate,
      invitedUserEmails: invitedUserEmails ?? [], // Default value
    );
    setRoom(newRoom);
  }

  Future<String?> createRoom() async {
    final room = state;
    if (room == null) return null;

    try {
      final newRoom = await roomService.addItem(room);

      return newRoom.id;
    } catch (e) {
      // todo: error handling
      return null;
    }
  }

  /// Sets the room being created.
  void setRoom(Room room) {
    state = room;
  }

  /// Clears the room being created.
  void clearRoom() {
    state = null;
  }

  /// Returns the room being created.
  Room? get room => state;
}
