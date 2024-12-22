import 'package:flutter/material.dart';
import 'package:sprintinio/widgets/user_interface/creating_room_form.dart';

class RootPage extends StatelessWidget {
  static const String path = '/';
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sprintinio'),
      ),
      body: const CreateRoomForm(),
    );
  }
}
