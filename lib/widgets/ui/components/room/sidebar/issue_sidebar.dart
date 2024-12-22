import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/models/ticket.dart';
import 'package:sprintinio/providers/can_manage_issues_provider.dart';
import 'package:sprintinio/providers/providers.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/providers/room_ticket_provider.dart';
import 'package:sprintinio/widgets/ui/components/room/issues/clickup_form.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';
import 'package:sprintinio/widgets/ui/components/room/issues/add_ticket_form.dart';
import 'package:sprintinio/widgets/ui/components/room/issues/ticket_card.dart';
import 'package:sprintinio/styles/colors.dart';
import 'package:sprintinio/util/clickup.dart';

final showClickUpContentProvider = StateProvider<bool>((ref) => false);
final isAddingIssueProvider = StateProvider<bool>((ref) => false);

class IssuesSidebar extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  final bool showSingleIssue;

  const IssuesSidebar(
      {super.key, required this.onClose, this.showSingleIssue = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IssuesSidebarState();
}

class _IssuesSidebarState extends ConsumerState<IssuesSidebar> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController clickUpLinkController = TextEditingController();

  Future<void> _submitTicket() async {
    final newTicket = Ticket(
      title: _titleController.text,
      description: _descriptionController.text,
      link: _linkController.text.trim().isEmpty ? null : _linkController.text,
    );
    try {
      final roomTickets = ref.read(roomTicketProvider.notifier);
      await roomTickets.addTicket(newTicket);

      _titleController.clear();
      _descriptionController.clear();
      _linkController.clear();
      ref.read(isAddingIssueProvider.notifier).state = false;
    } on FormatException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      return;
    }
  }

  void _onTapHeader() async {
    if (ref.read(accessTokenProvider) != null) {
      ref.read(showClickUpContentProvider.notifier).state = true;
      return;
    }
    final success = await ClickUpApi.authenticateClickUp(
        ref.read(accessTokenProvider.notifier));
    if (success) {
      ref.read(showClickUpContentProvider.notifier).state = true;
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to authenticate with ClickUp'),
          ),
        );
      }
    }
  }

  void _onPressedAddIssue() {
    ref.read(isAddingIssueProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    final currentRoom = ref.watch(currentRoomProvider);

    final canManageIssues = ref.watch(canManageIssuesProvider);
    final addIssue = ref.watch(isAddingIssueProvider);
    final tickets = currentRoom.value?.session?.tickets ?? [];
    final totalPoints = tickets.fold<double>(
      0.0,
      (previousValue, ticket) =>
          previousValue + (ticket.result?.numericAverage ?? 0.0),
    );

    final currentVotedTicket =
        currentRoom.value?.session?.votingProcess?.currentTicket;

    return Container(
      width: 400,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ref.watch(showClickUpContentProvider)
              ? _buildClickUpContent(context)
              : [
                  _buildHeader(context,
                      showSingleIssue: widget.showSingleIssue,
                      canManageIssues: canManageIssues),
                  const SizedBox(height: 8.0),
                  if (!widget.showSingleIssue)
                    Text(
                        '${tickets.length} Issues – ${totalPoints.toStringAsFixed(1)} points',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 14.0)),
                  const SizedBox(height: 16.0),
                  if (addIssue)
                    AddTicketForm(
                      titleController: _titleController,
                      descriptionController: _descriptionController,
                      linkController: _linkController,
                      onSubmit: _submitTicket,
                    )
                  else if (tickets.isEmpty && !widget.showSingleIssue)
                    _buildAddIssueButton(canManageIssues)
                  else
                    _buildTicketList(tickets, canManageIssues,
                        currentVotedTicket, widget.showSingleIssue),
                ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context,
      {bool showSingleIssue = false, required bool canManageIssues}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Builder(builder: (context) {
            String title = "Issues";
            if (showSingleIssue) {
              title = "Issue in voting progress";
            }
            return Text(title, style: TextStyles.largeBlack);
          }),
          const Spacer(),
          if (!showSingleIssue && canManageIssues)
            PopupMenuButton<String>(
              icon: const Icon(Icons.file_download_outlined),
              offset: const Offset(0, 40),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'Import from ClickUp',
                    onTap: _onTapHeader,
                    child: const Text('Import from ClickUp'),
                  ),
                ];
              },
            ),
          IconButton(icon: const Icon(Icons.close), onPressed: widget.onClose),
        ],
      ),
    );
  }

  Widget _buildAddIssueButton(bool show) {
    if (!show) return const SizedBox.shrink();
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: CustomPurpleButton(
          text: 'Add Issue',
          onPressed: _onPressedAddIssue,
        ),
      ),
    );
  }

  List<Widget> _buildClickUpContent(BuildContext context) {
    return [
      Builder(builder: (context) {
        return const ClickupForm();
      }),
    ];
  }

  Widget _buildTicketList(List<Ticket> tickets, bool canManageIssues,
      Ticket? singleIssue, bool showSingleIssue) {
    final List<Ticket> ticketList = showSingleIssue
        ? singleIssue != null
            ? [singleIssue]
            : []
        : tickets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap:
              true, // Ensures the ListView only occupies the space it needs
          physics:
              const NeverScrollableScrollPhysics(), // Disable scrolling of the inner ListView
          itemCount: ticketList.length,
          itemBuilder: (BuildContext context, int index) {
            final Ticket ticket = ticketList[index];
            return TicketCard(
              ticket: ticket,
              canManageIssues: canManageIssues,
              index: index,
            );
          },
        ),
        const SizedBox(height: 16.0),
        if (!showSingleIssue) _buildAddIssueButton(canManageIssues)
      ],
    );
  }
}
