import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/models/room_with_userinfo.dart';
import 'package:sprintinio/models/session_state.dart';
import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/providers/room_settings_provider.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/widgets/ui/components/general/text_input_field.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';
import 'package:sprintinio/widgets/ui/components/room/issues/issue_dropdown_widget.dart';
import 'package:sprintinio/widgets/ui/components/general/toggle_switch.dart';
import 'package:sprintinio/widgets/ui/components/customize/voting_dropdown_widget.dart';
import 'package:sprintinio/models/create_tickets_permission.dart';

class RoomSettingsSidebar extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const RoomSettingsSidebar({super.key, required this.onClose});

  @override
  RoomSettingsSidebarState createState() => RoomSettingsSidebarState();
}

class RoomSettingsSidebarState extends ConsumerState<RoomSettingsSidebar> {
  final TextEditingController _roomNameController = TextEditingController();
  bool? _isPrivateToggled;
  VotingSystem? _selectedVotingSystem;
  ManageIssuesPermission? _selectedManageIssuesPermission;

  @override
  void initState() {
    super.initState();
    final room = ref.read(currentRoomProvider).value;
    if (room != null) {
      _isPrivateToggled = room.isPrivate;
      _selectedVotingSystem = room.votingSystem;
      _selectedManageIssuesPermission = room.manageIssuesPermission;
    }
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  /// Toggle to switch between public and private room.
  void _onToggle(bool toggled) {
    setState(() {
      _isPrivateToggled = toggled;
    });
  }

  /// Save the room settings.
  void _onPressedSave(RoomWithUserinfo room) async {
    final roomSettings = ref.read(roomSettingsProvider.notifier);
    await roomSettings.updateRoomSettings(
      _roomNameController.text,
      _isPrivateToggled!,
      _selectedManageIssuesPermission!,
      _selectedVotingSystem!,
    );
    widget.onClose(); // Close the sidebar on save
  }

  void _onManageIssuesPermissionChanged(ManageIssuesPermission? newPermission) {
    setState(() {
      _selectedManageIssuesPermission = newPermission;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRoom = ref.watch(currentRoomProvider);
    final currentUser = ref.watch(currentUserProvider);

    final isCurrentUserGoogleAuthenticated = currentUser.value?.email != null;
    // Check if the room is in voting process to disable the voting system dropdown
    final isInVotingProcess =
        currentRoom.value?.session?.currentState == SessionState.voting ||
            currentRoom.value?.session?.currentState == SessionState.result;

    return Container(
      width: 400,
      height: double.infinity, // Take the full height of the screen
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: currentRoom.when(
        data: (room) {
          if (room == null ||
              currentUser.value == null ||
              currentUser.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_roomNameController.text.isEmpty) {
            _roomNameController.text = room.name;
          }

          _isPrivateToggled ??= room.isPrivate;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24.0),
                TextInputField(
                  placeholder: 'Room Name',
                  label: 'Room Name',
                  controller: _roomNameController,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 24.0),
                IssuesPermissionsDropdown(
                  initialValue: _selectedManageIssuesPermission,
                  onChanged: _onManageIssuesPermissionChanged,
                ),
                const SizedBox(height: 24.0),
                VotingSystemDropdown(
                  isDisabled: isInVotingProcess,
                  initialValue: _selectedVotingSystem,
                  onChanged: (VotingSystem value) {
                    setState(() {
                      _selectedVotingSystem = value;
                    });
                  },
                ),
                const SizedBox(height: 24.0),
                if (isCurrentUserGoogleAuthenticated) ...[
                  CustomToggleSwitch(
                    text: 'Private Room',
                    isToggled: _isPrivateToggled!,
                    onToggle: (bool toggled) => _onToggle(toggled),
                  ),
                  const SizedBox(height: 24.0),
                ],
                SizedBox(
                  width: double.infinity, // Make button take full width
                  child: CustomPurpleButton(
                    text: 'Save',
                    onPressed: () => _onPressedSave(room),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Settings',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onClose), // Close the sidebar on "x" press
        ],
      ),
    );
  }
}
