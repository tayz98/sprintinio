import 'package:flutter/material.dart';
import 'package:sprintinio/models/session_state.dart';
import 'package:sprintinio/styles/colors.dart';

class CustomCard extends StatelessWidget {
  final Color backgroundColor;
  final String? displayText;
  final double scale;
  final double? width;
  final double? height;
  final Widget? child;
  final SessionState? sessionState;
  final bool voted;
  final double textScale;

  const CustomCard({
    super.key,
    this.backgroundColor = AppColors.background,
    this.displayText,
    this.scale = 1.0,
    this.width = 0,
    this.height = 0,
    this.sessionState,
    this.voted = false,
    this.child,
    this.textScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final double scaledWidth = width! * scale;
    final double scaledHeight = height! * scale;

    return Container(
      width: width != 0 ? scaledWidth : null,
      height: height != 0 ? scaledHeight : null,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: child ??
          (displayText != null
              ? Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      displayText!,
                      style: TextStyle(
                        color: backgroundColor == AppColors.background
                            ? AppColors.purple
                            : AppColors.white,
                        fontSize:
                            24.0, // base size, it will be scaled down if necessary
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : null),
    );
  }
}
