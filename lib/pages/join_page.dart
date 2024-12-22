import 'package:flutter/material.dart';
import 'package:sprintinio/widgets/user_interface/join_room_form.dart';

class JoinPage extends StatelessWidget {
  static const String path = '/join';
  const JoinPage({super.key, this.roomId});
  final String? roomId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sprintinio'),
      ),
      body: JoinRoomForm(
        roomId: roomId,
      ),
    );
  }
}
