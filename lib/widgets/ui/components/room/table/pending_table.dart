import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/providers/can_manage_issues_provider.dart';
import 'package:sprintinio/providers/sidebar_provider.dart';
import 'package:sprintinio/util/enums.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/widgets/ui/components/room/sidebar/issue_sidebar.dart';
import 'package:sprintinio/widgets/ui/components/general/text_link.dart';

class PendingTable extends ConsumerStatefulWidget {
  const PendingTable({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PendingTableState();
  }
}

class _PendingTableState extends ConsumerState<PendingTable> {
  void _addIssues() {
    ref.read(isAddingIssueProvider.notifier).state = true;
    ref.read(sidebarProvider.notifier).openSidebar(SidebarType.issues);
  }

  @override
  Widget build(BuildContext context) {
    final canManageIssues = ref.watch(canManageIssuesProvider);

    if (canManageIssues) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bored?',
                style: TextStyles.smallGrey,
              ),
              SizedBox(width: 8),
              Text(
                '🥱',
                style: TextStyles.smallGrey,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextLink(
            onPressed: () => _addIssues(),
            text: 'Add Issues',
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
