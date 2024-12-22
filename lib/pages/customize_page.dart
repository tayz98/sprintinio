// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:sprintinio/providers/room_settings_provider.dart';
import 'package:sprintinio/providers/room_users_provider.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/util/avatar_manager.dart';
import 'package:sprintinio/models/avatar.dart';
import 'package:sprintinio/models/room.dart';
import 'package:sprintinio/models/room_user.dart';
import 'package:sprintinio/providers/auth_service_provider.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/providers/create_room_provider.dart';
import 'package:sprintinio/widgets/ui/components/customize/avatar_selection.dart';
import 'package:sprintinio/widgets/ui/components/general/toggle_switch.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';
import 'package:sprintinio/widgets/ui/components/general/text_input_field.dart';
import 'package:sprintinio/util/validators.dart';
import 'package:sprintinio/util/snackbars.dart';
import 'package:sprintinio/pages/room_page.dart';

class CustomizePage extends ConsumerStatefulWidget {
  const CustomizePage({
    super.key,
    required this.roomId,
    this.isCreateRoomMode = false,
  });

  final String roomId;
  static const String path = '/customize';
  final bool isCreateRoomMode;

  @override
  CustomizePageState createState() => CustomizePageState();
}

class CustomizePageState extends ConsumerState<CustomizePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  Avatar? _selectedAvatar;
  final Logger _logger = Logger();
  final FocusNode _focusNode = FocusNode();
  ButtonState _buttonState = ButtonState.idle;

  // State for spectator toggle switch
  bool _isSpectatorToggled = false;

  // Handle the current auth state and do the necessary actions with the auth provider to authenticated the user if it is not in the correct state
  // Returns true if the user is authenticated and ready to join the room
  // Returns false if the user authentication process fails
  Future<bool> _handleAuthState() async {
    late final authService = ref.read(authServiceProvider);
    final currentUserProviderNotifier = ref.read(currentUserProvider.notifier);
    // Get the current authentication state from the providers
    final bool isAlreadyAuthenticated =
        ref.read(currentUserProvider).value != null;
    final bool isAuthenticatedWithGoogle = isAlreadyAuthenticated &&
        await authService.getAuthMethod() == 'google.com';

    // If user tries to create a room
    if (widget.isCreateRoomMode) {
      final initializedRoom = ref.read(createRoomProvider);

      // private rooms need google authentication
      if (initializedRoom!.isPrivate) {
        if (isAuthenticatedWithGoogle) {
          await currentUserProviderNotifier.updateUserProfile(
              _nameController.text, _selectedAvatar!);
          return true;
        }
        return null !=
            await currentUserProviderNotifier.signInWithGoogle(
                _nameController.text, _selectedAvatar!);
        // Public create rooms need anonymous authentication
      } else if (!isAlreadyAuthenticated) {
        return null !=
            await currentUserProviderNotifier.signInAnonymously(
                _nameController.text, _selectedAvatar!);
      }
    }

    // If user tries to join a room
    if (!widget.isCreateRoomMode) {
      final room = await ref
          .read(roomSettingsProvider.notifier)
          .getRoomById(widget.roomId);

      // private rooms need google authentication
      if (room!.isPrivate) {
        if (isAuthenticatedWithGoogle) {
          await currentUserProviderNotifier.updateUserProfile(
              _nameController.text, _selectedAvatar!);
          return true;
        }
        return null !=
            await currentUserProviderNotifier.signInWithGoogle(
                _nameController.text, _selectedAvatar!);
      } else if (!isAlreadyAuthenticated) {
        return null !=
            await currentUserProviderNotifier.signInAnonymously(
                _nameController.text, _selectedAvatar!);
      }
    }

    await currentUserProviderNotifier.updateUserProfile(
        _nameController.text, _selectedAvatar!);
    return true;
  }

  Future<bool> _joinRoom(BuildContext context, String? roomId) async {
    // handle the user joining the room
    if (roomId == null) {
      throw Exception('Room ID is null');
    }

    // load the current user from the provider
    final currentUser = ref.read(currentUserProvider).value;

    // load the room from the room service
    final room =
        await ref.read(roomSettingsProvider.notifier).getRoomById(roomId);

    // if the room or user is not found, return false
    if (room == null || currentUser == null) {
      throw Exception('Room or user not found');
    }

    // Check if the user is already in the room by checking user id against all ids of roomUsers
    if (room.roomUsers.any((ru) => ru.id == currentUser.id)) {
      return true;
    }

    // Private room access control
    if (!widget.isCreateRoomMode && room.isPrivate) {
      // if the user is not invited to the room, return false
      if (room.invitedUserEmails == null ||
          !room.invitedUserEmails!.contains(currentUser.email)) {
        throw Exception('You are not invited to this room');
      }
    }

    // Adding the current firebase users email to the room whitelist for new private rooms
    if (widget.isCreateRoomMode && room.isPrivate) {
      await ref
          .read(roomSettingsProvider.notifier)
          .addInvitedUserEmail(roomId, currentUser.email!);
    }

    // Joining the user into the room
    final roomUser = RoomUser(
      id: currentUser.id,
      isHost: widget.isCreateRoomMode,
      isSpectator: _isSpectatorToggled,
    );

    // Add the user to the room
    final bool joinSuccess =
        await ref.read(roomUsersProvider.notifier).joinRoom(roomId, roomUser);

    if (!joinSuccess) {
      throw Exception('Failed to join the room');
    }

    return joinSuccess;
  }

  Future<String?> _createRoom(BuildContext context) async {
    try {
      // handle the room creation and return the room id if successful
      return await ref.read(createRoomProvider.notifier).createRoom();
    } catch (e) {
      throw Exception('Failed to create room');
    }
  }

  Future<void> _handleClick(Avatar avatar) async {
    if (_selectedAvatar == null) {
      setState(() {
        _selectedAvatar = avatar;
      });
    }
    setState(() {
      _buttonState = ButtonState.loading;
    });
    try {
      await _handleSubmit();
    } catch (e) {
      setState(() {
        _buttonState = ButtonState.idle;
      });
      rethrow;
    }
  }

  Future<void> _handleSubmit() async {
    // Handle the submit button including authentication, room creation, and joining
    final authSuccess = await _handleAuthState();
    if (!authSuccess) {
      throw Exception('Authentication failed');
    }

    if (!_formKey.currentState!.validate()) {
      throw Exception('Form validation failed');
    }

    // Get the room id from the widget
    String? roomId = widget.roomId;

    // Check if the state is create room mode
    if (widget.isCreateRoomMode) {
      // Create room and override the roomId that will be joined
      roomId = await _createRoom(context);
    }

    // Handle the user joining the room
    final bool success = await _joinRoom(context, roomId);
    if (success && mounted) {
      // Redirect
      context.go('${RoomPage.path}/$roomId');
    }
  }

  Future<void> _applyRoomChecks() async {
    // initial room checks
    // Create mode skip this check
    if (widget.isCreateRoomMode) {
      return;
    }

    // Check room if room exists
    Room? room;
    try {
      room = await ref
          .read(roomSettingsProvider.notifier)
          .getRoomById(widget.roomId);
      if (room == null) {
        throw Exception('Room not found');
      }
    } catch (e) {
      _logger.e(e);
      if (mounted) {
        SnackBarUtil.showErrorSnackbar(context, 'Room not found');
        context.go('/');
      }
    }

    // Check if user is already in room
    final currentUser = ref.read(authServiceProvider).currentUser;

    if (room!.roomUsers.any((ru) => ru.id == currentUser?.uid)) {
      if (mounted) {
        context.go('${RoomPage.path}/${widget.roomId}');
      }
    }
  }

  void _onKeyEvent(KeyEvent event, Avatar avatar) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      _handleClick(avatar);
    }
  }

  void _onSelected(Avatar value) {
    setState(() {
      _selectedAvatar = value;
    });
  }

  void _onToggle(bool toggled) {
    setState(() {
      _isSpectatorToggled = toggled;
    });
  }

  @override
  void initState() {
    super.initState();
    // Perform asynchronous operations
    _applyRoomChecks();
  }

  @override
  Widget build(BuildContext context) {
    Avatar? avatar;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 600,
            child: KeyboardListener(
              focusNode: _focusNode,
              onKeyEvent: (KeyEvent event) => _onKeyEvent(event, avatar!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choose your appearance',
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
                          child: Consumer(builder: (context, ref, child) {
                            final currentUser = ref.watch(currentUserProvider);

                            if (_selectedAvatar == null) {
                              avatar = currentUser.value?.avatar ??
                                  AvatarManager.getDefaultAvatar();
                            } else {
                              avatar = _selectedAvatar;
                            }

                            if (_nameController.text.isEmpty) {
                              _nameController.text =
                                  currentUser.value?.username ?? '';
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                TextInputField(
                                  controller: _nameController,
                                  label: 'Your Name',
                                  placeholder: 'E.g. John',
                                  validator: usernameValidator,
                                ),
                                const SizedBox(height: 32),
                                const Text('Your Avatar:',
                                    style: TextStyles.smallGreyHover),
                                const SizedBox(height: 10),
                                AvatarSelection(
                                  selectedAvatar: avatar!,
                                  avatars: AvatarManager.getAvatarList(),
                                  onSelected: (Avatar value) =>
                                      _onSelected(value),
                                ),
                                const SizedBox(height: 32),
                                CustomToggleSwitch(
                                  text: 'Join as spectator',
                                  isToggled: _isSpectatorToggled,
                                  onToggle: (bool toggled) =>
                                      _onToggle(toggled),
                                ),
                                const SizedBox(height: 32),
                                CustomPurpleButton(
                                  onPressed: () => _handleClick(avatar!),
                                  text: 'Continue',
                                  showLoading: true,
                                  state: _buttonState,
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
