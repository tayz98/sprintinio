import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/providers/room_voting_provider.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/models/ticket.dart';
import 'package:sprintinio/providers/can_manage_issues_provider.dart';
import 'package:sprintinio/styles/colors.dart';
import 'package:sprintinio/util/voting_systems.dart';
import 'package:sprintinio/widgets/ui/components/general/custom_white_button.dart';

class ResultTable extends ConsumerWidget {
  final Ticket ticket;

  const ResultTable({super.key, required this.ticket});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoom = ref.watch(currentRoomProvider).value;
    final canManageIssues = ref.watch(canManageIssuesProvider);

    final bool isVotingSystemTshirts =
        currentRoom?.votingSystem == VotingSystems.getVotingSystem("T-Shirts");

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.purple,
          borderRadius: BorderRadius.circular(16.0),
        ),
        width: 450,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Voting finished for',
              style: TextStyles.smallWhite,
            ),
            const SizedBox(height: 8),
            Text(
              ticket.title,
              style: TextStyles.mediumWhite,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            canManageIssues
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Average',
                            style: TextStyles.smallGrey,
                          ),
                          Text(
                            isVotingSystemTshirts
                                ? ticket.result!.systemAverage
                                : ticket.result!.numericAverage
                                    .toStringAsFixed(1),
                            style: TextStyles.largeWhite,
                          ),
                        ],
                      ),
                      Container(
                        width: 1.0,
                        height: 40.0,
                        color: AppColors.white,
                      ),
                      Column(
                        children: [
                          const Text(
                            'Agreement',
                            style: TextStyles.smallGrey,
                          ),
                          Text(
                            '${ticket.result!.agreement.toStringAsFixed(0)}%',
                            style: TextStyles.largeWhite,
                          ),
                        ],
                      ),
                      Builder(
                        builder: (context) {
                          return CustomWhiteButton(
                            text: 'Vote next Ticket',
                            onPressed: ref
                                .read(roomVotingProvider.notifier)
                                .voteNextTicket,
                          );
                        },
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Average',
                            style: TextStyles.smallGrey,
                          ),
                          Text(
                            ticket.result!.numericAverage.toStringAsFixed(1),
                            style: TextStyles.largeWhite,
                          ),
                        ],
                      ),
                      Container(
                        width: 1.0,
                        height: 40.0,
                        color: AppColors.white,
                      ),
                      Column(
                        children: [
                          const Text(
                            'Agreement',
                            style: TextStyles.smallGrey,
                          ),
                          Text(
                            '${ticket.result!.agreement.toStringAsFixed(0)}%',
                            style: TextStyles.largeWhite,
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
