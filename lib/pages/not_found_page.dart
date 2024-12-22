import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';

class NotFoundPage extends StatelessWidget {
  static const String path = '/404';
  const NotFoundPage({super.key});

  void _goToCreateRoom(BuildContext context) {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('404 Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'The room you are looking for does not exist.',
              style: TextStyles.largeBlack,
            ),
            const SizedBox(height: 20),
            CustomPurpleButton(
              onPressed: () => _goToCreateRoom(context),
              text: 'Create Room',
            ),
          ],
        ),
      ),
    );
  }
}
