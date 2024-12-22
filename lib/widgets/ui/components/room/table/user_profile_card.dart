import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/models/session_state.dart';
import 'package:sprintinio/models/combined_user.dart';
import 'package:sprintinio/models/vote.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/styles/colors.dart';

class UserProfileCard extends ConsumerWidget {
  final double scale;
  final double? width;
  final double? height;
  final SessionState? sessionState;
  final Vote? userVote;
  final CombinedUser user;

  const UserProfileCard({
    super.key,
    this.scale = 1.0,
    this.width,
    this.height,
    this.sessionState,
    this.userVote,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoom = ref.watch(currentRoomProvider).value;

    // Show loading indicator if current room is null
    if (currentRoom == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final sessionState = currentRoom.session?.currentState;
    final hasVoted =
        currentRoom.session!.votingProcess?.votes[user.firebaseUser.id] != null;
    final isCurrentUser =
        ref.read(currentUserProvider).value?.id == user.firebaseUser.id;
    final double scaledWidth = (width ?? 40) * scale;
    final double scaledHeight = (height ?? 60) * scale;

    // Getting the voting system to get the string representation of the vote
    final VotingSystem votingSystem = currentRoom.votingSystem;
    final String displayVote =
        (sessionState == SessionState.result && userVote != null) ||
                (isCurrentUser && hasVoted)
            ? votingSystem.votingType.getNameByValue(userVote?.vote) ?? ''
            : '';

    Color cardColor;
    Color textColor;

    if (sessionState != null &&
        (sessionState == SessionState.voting ||
            sessionState == SessionState.result) &&
        hasVoted) {
      cardColor = AppColors.purple;
      textColor = AppColors.white;
    } else {
      cardColor = AppColors.background;
      textColor = AppColors.purple;
    }

    return SizedBox(
      width: scaledWidth > 0 ? scaledWidth : 40,
      height: scaledHeight > 0 ? scaledHeight : 60,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                displayVote,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24.0 * scale,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
