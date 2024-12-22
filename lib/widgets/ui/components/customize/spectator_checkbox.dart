import 'package:flutter/material.dart';

class SpectatorCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const SpectatorCheckbox(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('spectate'),
        Checkbox(
          value: value,
          onChanged: (bool? newValue) => onChanged(newValue!),
        ),
      ],
    );
  }
}
