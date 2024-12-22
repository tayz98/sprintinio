import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/styles/colors.dart';
import 'package:sprintinio/styles/text_styles.dart';

class ProfileDropdown extends ConsumerStatefulWidget {
  final VoidCallback? onClick;
  const ProfileDropdown({super.key, this.onClick});

  @override
  ProfileDropdownState createState() => ProfileDropdownState();
}

class ProfileDropdownState extends ConsumerState<ProfileDropdown> {
  bool _isHovering = false;

  void _onEnter(PointerEvent event) {
    setState(() {
      _isHovering = true;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _isHovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;

    if (currentUser != null) {
      final Color bgColor = _isHovering ? AppColors.lightgrey : AppColors.white;

      return MouseRegion(
        onEnter: _onEnter,
        onExit: _onExit,
        child: InkWell(
          onTap: widget.onClick,
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: bgColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(currentUser.avatar.url),
                ),
                const SizedBox(width: 8),
                Text(
                  currentUser.username,
                  style: TextStyles.smallBlack,
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down,
                    size: 24, color: AppColors.black),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
