import 'package:flutter/material.dart';
import 'package:sprintinio/styles/button_styles.dart';

class TextLink extends StatelessWidget {
  final double size;
  final String text;
  final VoidCallback? onPressed;

  const TextLink({
    super.key,
    required this.text,
    this.onPressed,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyles.buildTextLinkButtonStyle(size),
      child: Text(text),
    );
  }
}
