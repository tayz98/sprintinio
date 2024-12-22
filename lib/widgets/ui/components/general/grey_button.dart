import 'package:flutter/material.dart';
import 'package:sprintinio/styles/button_styles.dart';
import 'package:sprintinio/styles/text_styles.dart';

class CustomGreyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomGreyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyles.greyButtonStyle,
      child: Text(
        text,
        style: TextStyles.smallBlack,
      ),
    );
  }
}
