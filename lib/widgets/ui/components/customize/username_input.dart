import 'package:flutter/material.dart';

class UsernameInput extends StatelessWidget {
  final TextEditingController controller;

  const UsernameInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a username';
        }
        if (value.length > 20) {
          return 'Username must be max. 20 characters long';
        }
        if (value.contains(' ')) {
          return 'Username must not contain spaces';
        }
        return null;
      },
      decoration: const InputDecoration(
          labelText: 'Username', hintText: "Enter your username"),
    );
  }
}
