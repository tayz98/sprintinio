import 'package:flutter/material.dart';

class RoomCodeInput extends StatelessWidget {
  final TextEditingController controller;

  const RoomCodeInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a room code';
        }
        if (value.length < 4 || value.length > 6) {
          return 'Room code must be 4-6 characters long';
        }
        if (value.contains(' ')) {
          return 'Room code must not contain spaces';
        }
        return null;
      },
      decoration: const InputDecoration(
          labelText: 'Room Code', hintText: "Enter the room code"),
    );
  }
}
