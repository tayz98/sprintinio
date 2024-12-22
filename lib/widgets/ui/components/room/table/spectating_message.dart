import 'package:flutter/material.dart';
import 'package:sprintinio/styles/text_styles.dart';

class SpectatingMessage extends StatelessWidget {
  const SpectatingMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        flex: 2,
        child: Center(
          child: Text(
            'You are spectating this room',
            style: TextStyles.mediumLightBlack,
          ),
        ));
  }
}
