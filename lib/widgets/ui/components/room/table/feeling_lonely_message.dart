import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/providers/sidebar_provider.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/util/enums.dart';
import 'package:sprintinio/widgets/ui/components/general/text_link.dart';
import 'package:sprintinio/widgets/ui/components/room/sidebar/issue_sidebar.dart';

class FeelingLonelyMessage extends ConsumerStatefulWidget {
  const FeelingLonelyMessage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FeelingLonelyMessageState();
  }
}

class _FeelingLonelyMessageState extends ConsumerState<FeelingLonelyMessage> {
  void _invitePlayers() {
    ref.read(isAddingIssueProvider.notifier).state = false;
    ref.read(sidebarProvider.notifier).openSidebar(SidebarType.invitePlayers);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Feeling lonely?',
                style: TextStyles.smallGreyText,
              ),
              SizedBox(width: 8.0),
              Text(
                '😪',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          TextLink(
            onPressed: _invitePlayers,
            text: 'Invite Players',
          ),
          const SizedBox(height: 48.0),
        ],
      ),
    );
  }
}
