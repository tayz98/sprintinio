import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/providers/room_users_provider.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/util/avatar_manager.dart';
import 'package:sprintinio/util/validators.dart';
import 'package:sprintinio/widgets/ui/components/customize/avatar_selection.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';
import 'package:sprintinio/widgets/ui/components/general/text_input_field.dart';
import 'package:sprintinio/models/avatar.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/widgets/ui/components/general/toggle_switch.dart';

class ProfileDropdownForm extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const ProfileDropdownForm({super.key, required this.onClose});

  @override
  ProfileDropdownFormState createState() => ProfileDropdownFormState();
}

class ProfileDropdownFormState extends ConsumerState<ProfileDropdownForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isSpectatorToggled = false;
  Avatar? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser != null) {
      _nameController.text = currentUser.username;
      _selectedAvatar = currentUser.avatar;
    }

    final currentRoomUser = ref
        .read(currentRoomProvider)
        .value!
        .users
        .firstWhereOrNull((user) => user.firebaseUser.id == currentUser?.id)
        ?.roomUser;
    if (currentRoomUser != null) {
      _isSpectatorToggled = currentRoomUser.isSpectator;
    }
  }

  void _handleAvatarSelected(Avatar value) {
    setState(() {
      _selectedAvatar = value;
    });
  }

  void _handleToggle(bool toggled) {
    setState(() {
      _isSpectatorToggled = toggled;
    });
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final roomUser = ref.read(roomUsersProvider.notifier);
      await roomUser.updateCurrentUserFromRoom(
        _nameController.text,
        _selectedAvatar!,
        _isSpectatorToggled,
      );

      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarList = AvatarManager.getAvatarList();

    return Container(
      width: 600,
      height: 620,
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
                  controller: _nameController,
                  label: 'Your Name',
                  placeholder: 'E.g. John',
                  validator: usernameValidator,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Your Avatar:',
                  style: TextStyles.smallGreyHover,
                ),
                const SizedBox(height: 10),
                AvatarSelection(
                  selectedAvatar: _selectedAvatar!,
                  avatars: avatarList,
                  onSelected: _handleAvatarSelected,
                ),
                const SizedBox(height: 32),
                CustomToggleSwitch(
                  text: 'Join as spectator',
                  isToggled: _isSpectatorToggled,
                  onToggle: _handleToggle,
                ),
                const SizedBox(height: 32),
                CustomPurpleButton(
                  onPressed: () => _handleSubmit(context),
                  text: 'Save',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
