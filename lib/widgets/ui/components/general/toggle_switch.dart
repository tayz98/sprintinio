import 'package:flutter/material.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/styles/colors.dart';

class CustomToggleSwitch extends StatefulWidget {
  final String text;
  final bool isToggled;
  final Function(bool) onToggle;

  const CustomToggleSwitch({
    super.key,
    required this.text,
    required this.isToggled,
    required this.onToggle,
  });

  @override
  CustomToggleSwitchState createState() => CustomToggleSwitchState();
}

class CustomToggleSwitchState extends State<CustomToggleSwitch> {
  bool _isHovered = false;

  void _onEnter(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onEnter(true),
      onExit: (_) => _onEnter(false),
      child: InkWell(
        onTap: () => widget.onToggle(!widget.isToggled),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 50,
              height: 25,
              decoration: BoxDecoration(
                color: _getColor(),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    top: 2.5,
                    left: widget.isToggled ? 25 : 0,
                    right: widget.isToggled ? 0 : 25,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: TextStyles.smallBlack,
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor() {
    if (widget.isToggled) {
      return _isHovered ? AppColors.purple : AppColors.purplePressed;
    } else {
      return _isHovered ? AppColors.greyHover : AppColors.grey;
    }
  }
}
