import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/providers/providers.dart';
import 'package:sprintinio/providers/room_ticket_provider.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/util/clickup.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';
import 'package:sprintinio/widgets/ui/components/room/sidebar/issue_sidebar.dart';

class ClickupForm extends ConsumerStatefulWidget {
  const ClickupForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ClickupFormState();
  }
}

class _ClickupFormState extends ConsumerState<ClickupForm> {
  final TextEditingController _clickUpLinkController = TextEditingController();

  void _onPressedAddIssueClickUp(String token) async {
    if (_clickUpLinkController.text.isEmpty) {
      const SnackBar(
        content: Text('Link is required'),
      );
      return;
    }
    final bool result = await ClickUpApi.fetchTasks(_clickUpLinkController.text,
        token, ref.read(roomTicketProvider.notifier));
    if (result) {
      _clickUpLinkController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Issue added successfully'),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Failed to import issue(s)\n Check your input again.'),
            ),
          );
        }
      }
    }
  }

  void _onPressedClose() {
    setState(() {
      ref.read(showClickUpContentProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final token = ref.watch(accessTokenProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Import ClickUp Issue',
                style: TextStyles.largeBlack,
              ),
              const SizedBox(height: 16.0),
              const Opacity(
                opacity: 0.7,
                child: Text("ClickUp Link"),
              ),
              TextField(
                controller: _clickUpLinkController,
                decoration: InputDecoration(
                  hintText: 'Link...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: CustomPurpleButton(
                  onPressed: () => _onPressedAddIssueClickUp(token!),
                  text: 'Add Issue',
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: _onPressedClose,
        ),
      ],
    );
  }
}
