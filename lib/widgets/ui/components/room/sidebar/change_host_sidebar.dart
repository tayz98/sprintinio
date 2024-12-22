import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/pages/room_page.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/providers/room_settings_provider.dart';
import 'package:sprintinio/styles/colors.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';
import 'package:sprintinio/models/combined_user.dart';
import 'package:sprintinio/models/room_user.dart';

class ChangeHostSidebar extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const ChangeHostSidebar({
    super.key,
    required this.onClose,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeHostSidebarState();
}

class _ChangeHostSidebarState extends ConsumerState<ChangeHostSidebar> {
  /// changes the host of the room
  void _changeHostOnPressed(RoomUser roomUser) {
    ref.read(roomSettingsProvider.notifier).changeHost(newHost: roomUser);
    widget.onClose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentRoom = ref.watch(currentRoomProvider);
    final currentUser = ref.watch(currentUserProvider);
    final clickedUser = ref.watch(clickedUserProvider.notifier).state!;
    final currentUserId = currentUser.value?.id;
    if (currentUserId == null) {
      throw Exception("Current user ID is null");
    }

    bool currentUserIsHost = false;

    final currentHost =
        currentRoom.value?.roomUsers.firstWhereOrNull((user) => user.isHost);
    if (currentHost?.id == currentUserId) {
      currentUserIsHost = true;
    }

    return _sideBarContent(
        context, clickedUser, currentUserIsHost, currentUserId, clickedUser);
  }

  Widget _sideBarContent(BuildContext context, CombinedUser user, bool isHost,
      String currentUserId, CombinedUser? clickedUser) {
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
          children: [
            _buildHeader(context, user.firebaseUser.username),
            const SizedBox(height: 24.0),
            if (isHost && (clickedUser?.firebaseUser.id != currentUserId))
              CustomPurpleButton(
                onPressed: () => _changeHostOnPressed(clickedUser!.roomUser),
                text: "Make Host",
                isFullWidth: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            userName,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }
}
