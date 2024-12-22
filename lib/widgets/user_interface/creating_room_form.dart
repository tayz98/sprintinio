import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprintinio/models/create_tickets_permission.dart';
import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/providers/create_room_provider.dart';
import 'package:sprintinio/widgets/ui/components/general/toggle_switch.dart';
import 'package:sprintinio/widgets/ui/components/room/sidebar/dynamic_email_list.dart';
import 'package:sprintinio/widgets/ui/components/general/text_input_field.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';
import 'package:sprintinio/widgets/ui/components/room/issues/issue_dropdown_widget.dart';
import 'package:sprintinio/widgets/ui/components/customize/voting_dropdown_widget.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/util/validators.dart';
import 'package:sprintinio/util/voting_systems.dart';

/// A form for creating a new room.
///
/// This form allows the user to create a new room by entering a name, selecting a voting system
/// and selecting ticket permissions.
class CreateRoomForm extends ConsumerStatefulWidget {
  const CreateRoomForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CreateRoomFormState();
  }
}

class _CreateRoomFormState extends ConsumerState<CreateRoomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _roomNameController = TextEditingController();
  ButtonState _buttonState = ButtonState.idle;

  // Invited emails list
  final List<String> _invitedUserEmails = [];

  bool _isPrivateToggled = false;

  final List<VotingSystem> _votingOptions = VotingSystems.options;
  VotingSystem? _selectedVotingSystem;
  ManageIssuesPermission? _selectedManageIssuesPermission;

  @override
  void initState() {
    super.initState();
    _selectedVotingSystem = _votingOptions.first;
    _selectedManageIssuesPermission = ManageIssuesPermission.onlyHost;
  }

  // Handle invited emails state change from DynamicEmailList
  void _handleEmailsChanged(List<String> emails) {
    setState(() {
      _invitedUserEmails.clear();
      _invitedUserEmails.addAll(emails);
    });
  }

  Future<void> _handleClick() async {
    setState(() {
      _buttonState = ButtonState.loading;
    });

    try {
      await _createGame();
    } catch (e) {
      setState(() {
        _buttonState = ButtonState.idle;
      });
      rethrow;
    }
  }

  /// Initializes the room and navigates to join/create.
  Future<void> _createGame() async {
    if (!_formKey.currentState!.validate()) {
      throw Exception('Form is not valid');
    }

    if (_roomNameController.text.isEmpty) {
      throw Exception('Room name is empty');
    }

    ref.read(createRoomProvider.notifier).initializeRoom(
          id: '',
          name: _roomNameController.text,
          votingSystem: _selectedVotingSystem!,
          manageIssuesPermission: _selectedManageIssuesPermission!,
          isPrivate: _isPrivateToggled,
          invitedUserEmails: _isPrivateToggled ? _invitedUserEmails : null,
        );
    // Navigate to JoinPage
    context.go('/customize/create');
  }

  void _onToggle(bool isToggled) {
    setState(() {
      _isPrivateToggled = isToggled;
    });
  }

  void _onVotingSystemChanged(VotingSystem newVotingSystem) {
    setState(() {
      _selectedVotingSystem = newVotingSystem;
    });
  }

  void _onManageIssuesPermissionChanged(ManageIssuesPermission? newPermission) {
    setState(() {
      _selectedManageIssuesPermission = newPermission;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create a game',
                      style: TextStyles.largeBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(32.0),
                      color: Colors.white,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextInputField(
                              controller: _roomNameController,
                              label: 'Name',
                              placeholder: 'E.g. Sprint planning...',
                              validator: roomNameValidator,
                            ),
                            const SizedBox(height: 20),
                            VotingSystemDropdown(
                              initialValue: _selectedVotingSystem,
                              onChanged: _onVotingSystemChanged,
                            ),
                            const SizedBox(height: 20),
                            IssuesPermissionsDropdown(
                              initialValue: _selectedManageIssuesPermission,
                              onChanged: _onManageIssuesPermissionChanged,
                            ),
                            const SizedBox(height: 20.0),
                            CustomToggleSwitch(
                              text: 'Private Room',
                              isToggled: _isPrivateToggled,
                              onToggle: _onToggle,
                            ),
                            const SizedBox(height: 20.0),
                            if (_isPrivateToggled)
                              DynamicEmailList(
                                  onEmailsChanged: _handleEmailsChanged),
                            const SizedBox(height: 20.0),
                            CustomPurpleButton(
                              text: 'Create game',
                              onPressed: _handleClick,
                              state: _buttonState,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
