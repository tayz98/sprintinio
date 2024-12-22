import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/models/session_state.dart';
import 'package:sprintinio/widgets/ui/components/room/table/pending_table.dart';
import 'package:sprintinio/widgets/ui/components/room/table/result_table.dart';
import 'package:sprintinio/widgets/ui/components/room/table/voting_table.dart';
import 'package:sprintinio/styles/colors.dart';

class TableItem extends ConsumerWidget {
  final int flex;
  const TableItem({super.key, this.flex = 1});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoom = ref.watch(currentRoomProvider).value;

    // Show loading indicator if current room is null
    if (currentRoom == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Expanded(
      flex: flex,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 600,
          maxWidth: 1000,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: currentRoom.session!.currentState == SessionState.result
                ? AppColors.purple
                : AppColors.lightgrey,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: AppColors.background),
          ),
          child: Center(
            child: currentRoom.session?.currentState == SessionState.pending
                ? const PendingTable()
                : currentRoom.session?.currentState == SessionState.voting
                    ? VotingTable(
                        ticket:
                            currentRoom.session!.votingProcess!.currentTicket!)
                    : currentRoom.session?.currentState == SessionState.result
                        ? ResultTable(
                            ticket: currentRoom
                                .session!.votingProcess!.currentTicket!)
                        : const SizedBox(),
          ),
        ),
      ),
    );
  }
}
