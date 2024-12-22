import 'package:flutter/material.dart';
import 'package:sprintinio/styles/button_styles.dart';
import 'package:sprintinio/styles/text_styles.dart';

class CustomWhiteButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;

  const CustomWhiteButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyles.whiteButtonStyle,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyles.smallPurple,
          ),
        ),
      ),
    );
  }
}
