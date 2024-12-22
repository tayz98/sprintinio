import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/models/ticket.dart';
import 'package:sprintinio/providers/sidebar_provider.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/pages/room_page.dart';
import 'package:sprintinio/util/enums.dart';

class VotingTable extends ConsumerStatefulWidget {
  final Ticket ticket;

  const VotingTable({super.key, required this.ticket});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VotingTableState();
  }
}

class _VotingTableState extends ConsumerState<VotingTable> {
  /// Opens the sidebar and shows current voted issue.
  void _onPressedOpenIssue() {
    ref.read(showSingleIssueProvider.notifier).state = widget.ticket;
    ref.read(sidebarProvider.notifier).openSidebar(SidebarType.singleIssue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Vote in progress for',
          style: TextStyles.smallGreyText,
        ),
        const SizedBox(height: 8, width: 8),
        TextButton(
          onPressed: _onPressedOpenIssue,
          child: Text(
            widget.ticket.title,
            style: TextStyles.mediumPurple,
          ),
        ),
      ],
    );
  }
}
