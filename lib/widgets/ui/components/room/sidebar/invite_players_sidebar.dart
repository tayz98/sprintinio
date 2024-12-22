import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/providers/room_settings_provider.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/widgets/ui/components/room/sidebar/dynamic_email_list.dart';
import 'package:sprintinio/widgets/ui/components/general/disabled_text_field.dart';
import 'package:sprintinio/styles/colors.dart';
import 'package:sprintinio/util/misc.dart';

class InvitePlayersSidebar extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const InvitePlayersSidebar({super.key, required this.onClose});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      InvitePlayersSidebarState();
}

class InvitePlayersSidebarState extends ConsumerState<InvitePlayersSidebar> {
  // Invited emails list (State of this widget)
  final List<String> _currentInvitedUserEmails = [];

  @override
  void initState() {
    super.initState();
    final currentRoom = ref.read(currentRoomProvider).value;
    _initializeEmails(currentRoom?.invitedUserEmails ?? []);
  }

  void _initializeEmails(List<String> emails) {
    setState(() {
      _currentInvitedUserEmails.clear();
      _currentInvitedUserEmails.addAll(emails);
    });
  }

  // Handle invited emails state change from DynamicEmailList
  void _handleEmailsChanged(List<String> emails) {
    setState(() {
      _currentInvitedUserEmails.clear();
      _currentInvitedUserEmails.addAll(emails);
    });
    _updateInvitedUsers();
  }

  // Update the room invited users emails in the database
  void _updateInvitedUsers() async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom != null) {
      ref
          .read(roomSettingsProvider.notifier)
          .updateInvitedUserEmails(_currentInvitedUserEmails);
    }
  }

  void _onCopy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _getShortCode(String roomUrl) {
    return UtilMisc.generateShortCode(roomUrl.split('/').last);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentRoom = ref.watch(currentRoomProvider);

        final roomUrl = ref
            .read(currentRoomProvider.notifier)
            .generateRoomLink(); // Get the room URL from the room controller
        final bool isRoomPrivate = currentRoom.value?.isPrivate ?? false;

        return Container(
          width: 400,
          height: double.infinity, // Take the full height of the screen
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
              children: [
                _buildHeader(context),
                const SizedBox(height: 24.0),
                DisabledTextField(
                  label: 'Room URL',
                  text: roomUrl,
                  onCopy: () => _onCopy(roomUrl),
                ),
                const SizedBox(height: 24.0),
                DisabledTextField(
                  label: 'Room Code',
                  text: _getShortCode(roomUrl),
                  onCopy: () => _onCopy(_getShortCode(roomUrl)),
                ),
                const SizedBox(height: 24.0),
                if (isRoomPrivate) ...[
                  DynamicEmailList(
                    onEmailsChanged: _handleEmailsChanged,
                    initialEmails: _currentInvitedUserEmails,
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Invite players',
            style: TextStyles.largeBlack,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onClose, // Use the onClose callback
          ),
        ],
      ),
    );
  }
}
