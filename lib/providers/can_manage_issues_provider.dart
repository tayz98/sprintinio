import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/models/create_tickets_permission.dart';

part 'can_manage_issues_provider.g.dart';

@riverpod
bool canManageIssues(CanManageIssuesRef ref) {
  final currentUser = ref.watch(currentUserProvider).value;
  final currentRoom = ref.watch(currentRoomProvider).value;

  if (currentRoom == null || currentUser == null) {
    return false; // Default to false if data isn't available yet
  }

  final manageIssuesPermission = currentRoom.manageIssuesPermission;

  if (manageIssuesPermission == ManageIssuesPermission.everyone) {
    return true;
  } else if (manageIssuesPermission == ManageIssuesPermission.onlyHost) {
    final matchingUser = currentRoom.roomUsers.firstWhereOrNull(
      (user) => user.id == currentUser.id,
    );
    return matchingUser != null && matchingUser.isHost;
  } else {
    return false;
  }
}
