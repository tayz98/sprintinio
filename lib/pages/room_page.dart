// ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/providers/room_users_provider.dart';
import 'package:sprintinio/models/ticket.dart';
import 'package:sprintinio/providers/sidebar_provider.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/util/enums.dart';
import 'package:sprintinio/widgets/ui/components/room/sidebar/change_host_sidebar.dart';
import 'package:sprintinio/widgets/ui/components/room/sidebar/room_settings_sidebar.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/widgets/ui/components/customize/profile_dropdown.dart';
import 'package:sprintinio/widgets/user_interface/table_room.dart';
import 'package:sprintinio/widgets/ui/components/customize/profile_dropdown_form.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';
import 'package:sprintinio/widgets/ui/components/room/sidebar/invite_players_sidebar.dart';
import 'package:sprintinio/widgets/ui/components/room/sidebar/issue_sidebar.dart';
import 'package:sprintinio/styles/colors.dart';
import 'package:sprintinio/models/combined_user.dart';

final clickedUserProvider = StateProvider<CombinedUser?>((ref) {
  return null;
});

/// Provider that holds a single issue to display.
final showSingleIssueProvider = StateProvider<Ticket?>((ref) => null);

/// A page for a room.
///
/// This room can host a session where users can vote on tickets.
class RoomPage extends ConsumerStatefulWidget {
  static const String path = '/room';
  const RoomPage({
    super.key,
    required this.roomId,
  });
  final String roomId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _RoomPageState();
  }
}

class _RoomPageState extends ConsumerState<RoomPage> {
  bool _isProfileFormVisible = false;

  @override
  void initState() {
    super.initState();
  }

  /// Toggle the visibility of the profile form.
  void _toggleProfileFormVisibility() {
    setState(() {
      _isProfileFormVisible = !_isProfileFormVisible;
    });
  }

  /// Close the profile form.
  void _closeProfileForm() {
    setState(() {
      _isProfileFormVisible = false;
    });
  }

  /// Close the sidebar.
  void _closeSidebar() {
    ref.read(isAddingIssueProvider.notifier).state = false;
    ref.read(clickedUserProvider.notifier).state = null;
    ref.read(sidebarProvider.notifier).closeSidebar();
  }

  /// Leave the room.
  void _leaveRoom() async {
    final roomUser = ref.read(roomUsersProvider.notifier);
    await roomUser.leaveRoom();
    if (context.mounted) context.go('/');
  }

  /// Show the invite players sidebar.
  void _invitePlayersOnPressed() {
    ref.read(isAddingIssueProvider.notifier).state = false;
    ref.read(sidebarProvider.notifier).openSidebar(SidebarType.invitePlayers);
  }

  /// Show the issues sidebar.
  void _showIssuesOnPressed() {
    ref.read(sidebarProvider.notifier).openSidebar(SidebarType.issues);
  }

  /// Show the room settings sidebar.
  void _showRoomSettingsOnPressed() {
    ref.read(isAddingIssueProvider.notifier).state = false;
    ref.read(sidebarProvider.notifier).openSidebar(SidebarType.roomSettings);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isSidebarVisible = ref.watch(sidebarProvider);
    final currentSidebarType = ref.watch(sidebarProvider.notifier).sidebarType;
    final currentRoom = ref.watch(currentRoomProvider).value;

    // If there is no currentRoom show a loading indicator.
    if (currentRoom == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final isCurrentUserHost = currentRoom.users
            .firstWhereOrNull(
                (user) => user.firebaseUser.id == currentUser.value?.id)
            ?.roomUser
            .isHost ??
        false;

    // Render the currentRoom
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: Image.asset(
          'assets/logo/Logo.png',
        ),
        title: Text(
          'Room Name: ${currentRoom.name}',
          style: TextStyles.largeBlack,
        ),
        titleSpacing: 0.0,
        actions: [
          ProfileDropdown(onClick: _toggleProfileFormVisibility),
          const SizedBox(width: 16.0),
          CustomPurpleButton(
            text: 'Invite Players',
            onPressed: _invitePlayersOnPressed,
            iconData: Icons.people_rounded,
          ),
          const SizedBox(width: 16.0),
          CustomPurpleButton(
            text: 'Show Issues',
            onPressed: _showIssuesOnPressed,
            iconData: Icons.file_copy,
          ),
          if (isCurrentUserHost)
            Row(
              children: [
                const SizedBox(width: 16.0),
                CustomPurpleButton(
                  onPressed: _showRoomSettingsOnPressed,
                  iconData: Icons.settings,
                ),
              ],
            ),
          const SizedBox(width: 16.0),
          CustomPurpleButton(
            onPressed: () => _leaveRoom(),
            iconData: Icons.exit_to_app,
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: Stack(
        children: [
          const TableRoomGridView(),
          if (_isProfileFormVisible)
            Positioned(
              top: 20,
              left: 820,
              right: 0,
              child: GestureDetector(
                onTap: _closeProfileForm,
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: ProfileDropdownForm(onClose: _closeProfileForm),
                  ),
                ),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: 0,
            bottom: 0,
            right: isSidebarVisible ? 0 : -600, // Slide in from the right
            child: Material(
              elevation: 8,
              child: Container(
                  color: Colors.white,
                  child: _buildSidebar(
                    currentSidebarType,
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebar(SidebarType type) {
    switch (type) {
      case SidebarType.invitePlayers:
        return InvitePlayersSidebar(onClose: _closeSidebar);
      case SidebarType.issues:
        return IssuesSidebar(onClose: _closeSidebar);
      case SidebarType.roomSettings:
        return RoomSettingsSidebar(onClose: _closeSidebar);
      case SidebarType.makeHost:
        return ChangeHostSidebar(onClose: _closeSidebar);
      case SidebarType.singleIssue:
        return IssuesSidebar(onClose: _closeSidebar, showSingleIssue: true);
      case SidebarType.none:
      default:
        return const SizedBox
            .shrink(); // Returns an empty widget when no sidebar should be displayed.
    }
  }
}
