import 'package:flutter/material.dart';
import 'package:sprintinio/models/avatar.dart';
import 'package:sprintinio/styles/colors.dart';

class AvatarSelection extends StatefulWidget {
  final List<Avatar> avatars;
  final Avatar selectedAvatar;
  final Function(Avatar) onSelected;

  const AvatarSelection(
      {super.key,
      required this.avatars,
      required this.onSelected,
      required this.selectedAvatar});

  @override
  State<AvatarSelection> createState() => _AvatarSelectionState();
}

class _AvatarSelectionState extends State<AvatarSelection> {
  Avatar? _selectedAvatar;

  void _onTap(Avatar avatar) {
    setState(() {
      _selectedAvatar = avatar;
      widget.onSelected(avatar);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedAvatar = widget.selectedAvatar;
    });
  }

  @override
  void didUpdateWidget(AvatarSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedAvatar != oldWidget.selectedAvatar) {
      setState(() {
        _selectedAvatar = widget.selectedAvatar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.avatars.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        final avatar = widget.avatars[index];
        final isSelected = _selectedAvatar == avatar;

        return GestureDetector(
          onTap: () => _onTap(avatar),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: isSelected ? AppColors.purple : Colors.transparent,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(avatar.url),
            ),
          ),
        );
      },
    );
  }
}
