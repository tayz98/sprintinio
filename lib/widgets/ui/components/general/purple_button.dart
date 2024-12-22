import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sprintinio/styles/button_styles.dart';
import 'package:sprintinio/styles/colors.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/util/snackbars.dart';

enum ButtonState {
  idle,
  loading,
}

class CustomPurpleButton extends StatefulWidget {
  final String? text;
  final IconData? iconData;
  final FutureOr<void> Function()? onPressed;
  final bool showLoading;
  final ButtonState state;
  final bool isFullWidth;

  const CustomPurpleButton({
    super.key,
    this.text,
    this.iconData,
    required this.onPressed,
    this.showLoading = false,
    this.state = ButtonState.idle,
    this.isFullWidth = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomPurpleButtonState();
  }
}

class _CustomPurpleButtonState extends State<CustomPurpleButton> {
  void _onPressed() async {
    try {
      await widget.onPressed?.call();
    } catch (e) {
      if (mounted) SnackBarUtil.showErrorSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: widget.state != ButtonState.loading ? _onPressed : null,
        style: ButtonStyles.purpleButtonStyle,
        child: widget.state == ButtonState.loading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.iconData != null) ...[
                    Icon(
                      widget.iconData,
                      color: AppColors.white,
                    ),
                    if (widget.text != null && widget.text!.isNotEmpty)
                      const SizedBox(width: 8.0),
                  ],
                  if (widget.text != null && widget.text!.isNotEmpty)
                    Text(
                      widget.text!,
                      style: TextStyles.smallWhite,
                    ),
                ],
              ),
      ),
    );
  }
}
