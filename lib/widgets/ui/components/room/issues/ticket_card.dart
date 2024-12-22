import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/providers/room_ticket_provider.dart';
import 'package:sprintinio/providers/room_voting_provider.dart';
import 'package:sprintinio/providers/sidebar_provider.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/util/snackbars.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sprintinio/models/session_state.dart';
import 'package:sprintinio/models/ticket.dart';
import 'package:sprintinio/models/ticket_result.dart';
import 'package:sprintinio/styles/colors.dart';
import 'package:sprintinio/widgets/ui/components/general/grey_button.dart';
import 'package:sprintinio/widgets/ui/components/general/text_link.dart';
import 'package:sprintinio/widgets/ui/components/general/card_element.dart';

class TicketCard extends ConsumerStatefulWidget {
  final Ticket ticket;
  final bool canManageIssues;
  final int index;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.canManageIssues,
    required this.index,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TicketCardState();
  }
}

class _TicketCardState extends ConsumerState<TicketCard> {
  bool descriptionIsExpanded = false;
  final int maxDescriptionLengthBeforeExpanded = 65;
  // Open the given url in a new tab
  void _openLinkInNewTab(String urlString) async {
    // Build url from url string
    try {
      final url = Uri.parse(urlString);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, webOnlyWindowName: '_blank');
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Logger().e(e);
      if (context.mounted) {
        SnackBarUtil.showErrorSnackbar(
            // ignore: use_build_context_synchronously
            context,
            "Could not open link in new tab: '$urlString'");
      }
    }
  }

  void _onPressedStartOrStopVoting(bool canStopVoting, Ticket ticket) {
    final roomVoting = ref.read(roomVotingProvider.notifier);

    if (canStopVoting) {
      roomVoting.cancelVotingProcess();
    } else {
      roomVoting.startVotingProcess(ticket.id);
      ref.read(sidebarProvider.notifier).closeSidebar();
    }
  }

  void _onPressedForceFinishVoting() async {
    await ref.read(roomVotingProvider.notifier).finalizeVoting();
  }

  void _toggleExpanded() {
    setState(() {
      descriptionIsExpanded = !descriptionIsExpanded;
    });
  }

  void _onSelected(int value) {
    if (value == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text(
                'Are you sure you want to delete the ticket "${widget.ticket.title}"?'),
            actions: <Widget>[
              TextButton(
                onPressed: _onPressedCancel,
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: _onPressedDelete,
                child: const Text('Delete',
                    style: TextStyle(color: AppColors.red)),
              ),
            ],
          );
        },
      );
    }
  }

  void _onPressedCancel() {
    Navigator.of(context).pop();
  }

  void _onPressedDelete() async {
    if (context.mounted) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
    await ref.read(roomTicketProvider.notifier).deleteTicket(widget.ticket.id);
  }

  @override
  Widget build(BuildContext context) {
    // if the description is longer than the max length, show a button to expand the description
    final showMoreButton =
        widget.ticket.description.length > maxDescriptionLengthBeforeExpanded;
    // used to show either the full description or a shortened version
    final displayDescription = descriptionIsExpanded || !showMoreButton
        ? widget.ticket.description
        : '${widget.ticket.description.substring(0, maxDescriptionLengthBeforeExpanded)}...';
    final TicketResult? result = widget.ticket.result;
    final currentRoom = ref.watch(currentRoomProvider);

    final currentTicket =
        currentRoom.value?.session?.votingProcess?.currentTicket;
    final bool isVoting = currentTicket?.id == widget.ticket.id;
    final bool canStopVoting = isVoting &&
        currentRoom.value?.session?.currentState == SessionState.voting;

    return Card(
      color: AppColors.lightgrey,
      surfaceTintColor: AppColors.lightgrey,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 8.0),
            if (widget.ticket.description.isNotEmpty)
              Text(
                displayDescription,
                style: const TextStyle(fontSize: 14.0),
              ),
            const SizedBox(height: 4.0),
            if (showMoreButton)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _toggleExpanded,
                  child: Text(
                    descriptionIsExpanded ? 'Show less' : 'Show more',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
            if (widget.ticket.description.isNotEmpty)
              const SizedBox(height: 8.0),
            if (widget.ticket.link != null && widget.ticket.link!.isNotEmpty)
              TextLink(
                text: 'Visit Ticket-Link',
                size: 14,
                onPressed: () => _openLinkInNewTab(widget.ticket.link!),
              ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Builder(builder: (context) {
                  if (widget.canManageIssues) {
                    return CustomGreyButton(
                      text: canStopVoting
                          ? 'Stop Voting'
                          : (result == null ? 'Start voting' : 'Vote again'),
                      onPressed: () => _onPressedStartOrStopVoting(
                          canStopVoting, widget.ticket),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                const Spacer(),
                Builder(builder: (context) {
                  if (widget.canManageIssues && canStopVoting) {
                    return CustomGreyButton(
                      text: 'Finish Voting',
                      onPressed: _onPressedForceFinishVoting,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                const Spacer(),
                const SizedBox(width: 8.0),
                CustomCard(
                  width: 40,
                  height: 60,
                  backgroundColor:
                      result == null ? AppColors.grey : AppColors.purple,
                  displayText: result == null
                      ? ''
                      : result.numericAverage.toStringAsFixed(1),
                  textScale: 0.6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.ticket.title,
            style: TextStyles.smallBlack,
          ),
        ),
        if (widget.canManageIssues)
          PopupMenuButton<int>(
            onSelected: (value) => _onSelected(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text('Delete'),
              ),
            ],
          ),
      ],
    );
  }
}
