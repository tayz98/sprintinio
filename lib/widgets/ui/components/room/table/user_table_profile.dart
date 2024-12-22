import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/models/combined_user.dart';
import 'package:sprintinio/models/player_on_table_orientation.dart';
import 'package:sprintinio/providers/sidebar_provider.dart';
import 'package:sprintinio/widgets/ui/components/room/table/user_circle_avatar.dart';
import 'package:sprintinio/widgets/ui/components/room/table/user_profile_card.dart';
import 'package:sprintinio/pages/room_page.dart';
import 'package:sprintinio/util/enums.dart';

class UserTableProfile extends ConsumerStatefulWidget {
  final CombinedUser user;
  final PlayerOnTableOrientation orientation;

  const UserTableProfile({
    super.key,
    required this.user,
    required this.orientation,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserTableProfileState();
  }
}

class _UserTableProfileState extends ConsumerState<UserTableProfile> {
  void _onTap() {
    final CombinedUser? prevClickedUser =
        ref.read(clickedUserProvider.notifier).state;

    ref.read(clickedUserProvider.notifier).state = widget.user;
    ref.read(sidebarProvider.notifier).openSidebar(SidebarType.makeHost,
        condition: prevClickedUser == widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final currentRoom = ref.watch(currentRoomProvider).value;

    // Show loading indicator if current room is null
    if (currentRoom == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final isSpectator = widget.user.roomUser.isSpectator;
    final isCurrentUser = widget.user.isCurrentUser;
    final userVote =
        currentRoom.session?.votingProcess?.votes[widget.user.firebaseUser.id];

    Widget profileWidget;
    switch (widget.orientation) {
      case PlayerOnTableOrientation.left:
        profileWidget = Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isSpectator)
              UserProfileCard(
                  width: 40,
                  height: 60,
                  user: widget.user,
                  sessionState: currentRoom.session!.currentState,
                  userVote: userVote),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: _onTap,
                    child: UserCircleAvatar(
                        url: widget.user.firebaseUser.avatar.url,
                        isCurrentUser: isCurrentUser,
                        isSpectator: isSpectator)),
                const SizedBox(height: 10),
                Text(widget.user.firebaseUser.username),
              ],
            ),
            const SizedBox(width: 10),
          ],
        );
        break;
      case PlayerOnTableOrientation.right:
        profileWidget = Row(
          children: [
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _onTap,
                  child: UserCircleAvatar(
                      url: widget.user.firebaseUser.avatar.url,
                      isCurrentUser: isCurrentUser,
                      isSpectator: isSpectator),
                ),
                const SizedBox(height: 10),
                Text(widget.user.firebaseUser.username),
              ],
            ),
            const SizedBox(width: 10),
            if (!isSpectator)
              UserProfileCard(
                  width: 40,
                  height: 60,
                  user: widget.user,
                  sessionState: currentRoom.session!.currentState,
                  userVote: userVote),
          ],
        );
        break;
      case PlayerOnTableOrientation.top:
        profileWidget = Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isSpectator)
              UserProfileCard(
                  width: 40,
                  height: 60,
                  user: widget.user,
                  sessionState: currentRoom.session!.currentState,
                  userVote: userVote),
            const SizedBox(height: 10),
            InkWell(
                onTap: _onTap,
                child: UserCircleAvatar(
                    url: widget.user.firebaseUser.avatar.url,
                    isCurrentUser: isCurrentUser,
                    isSpectator: isSpectator)),
            const SizedBox(height: 10),
            Text(widget.user.firebaseUser.username),
            const SizedBox(height: 10),
          ],
        );
        break;
      case PlayerOnTableOrientation.bottom:
        profileWidget = Column(
          children: [
            const SizedBox(height: 10),
            InkWell(
              onTap: _onTap,
              child: UserCircleAvatar(
                  url: widget.user.firebaseUser.avatar.url,
                  isCurrentUser: isCurrentUser,
                  isSpectator: isSpectator),
            ),
            const SizedBox(height: 10),
            Text(widget.user.firebaseUser.username),
            const SizedBox(height: 10),
            if (!isSpectator)
              UserProfileCard(
                  width: 40,
                  height: 60,
                  user: widget.user,
                  sessionState: currentRoom.session!.currentState,
                  userVote: userVote),
          ],
        );
        break;
    }
    return Opacity(
      opacity: isSpectator ? 0.5 : 1.0,
      child: profileWidget,
    );
  }
}
