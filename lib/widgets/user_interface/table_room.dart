import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/models/combined_user.dart';
import 'package:sprintinio/models/player_on_table_orientation.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/widgets/ui/components/room/table/feeling_lonely_message.dart';
import 'package:sprintinio/widgets/ui/components/room/table/spectating_message.dart';
import 'package:sprintinio/widgets/ui/components/room/table/table_grid_item.dart';
import 'package:sprintinio/widgets/ui/components/room/table/table_item.dart';
import 'package:sprintinio/models/session_state.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/widgets/ui/components/room/table/voting_ui.dart';

class TableRoomGridView extends ConsumerStatefulWidget {
  const TableRoomGridView({super.key});

  @override
  TableRoomGridViewState createState() => TableRoomGridViewState();
}

class TableRoomGridViewState extends ConsumerState<TableRoomGridView> {
  late List<List<CombinedUser>> grid;
  late List<Widget> topRow, bottomRow, leftColumn, rightColumn;
  late bool isCurrentUserSpectator, isSessionVoting;

  @override
  void initState() {
    super.initState();
    grid = List.generate(4, (_) => []);
    topRow = [];
    bottomRow = [];
    leftColumn = [];
    rightColumn = [];
  }

  @override
  Widget build(BuildContext context) {
    final currentRoom = ref.watch(currentRoomProvider).value;

    // Show loading indicator if current room is null
    if (currentRoom == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final int width = MediaQuery.of(context).size.width.toInt();
    final int height = MediaQuery.of(context).size.height.toInt();
    const int tableWidth = 500;
    final int tableHeight = 280 + (currentRoom.users.length > 12 ? 40 : 0);
    final double? appBarHeight = Scaffold.of(context).appBarMaxHeight;

    final int widthSides = ((width - tableWidth) ~/ 2);
    final int heightSides = ((height - tableHeight) ~/ 2);

    const int heightVotingUi = 250;
    final int heightVotingUISides =
        ((height - tableHeight - heightVotingUi) ~/ 2);

    // Build the grid with the current room users
    _buildRoomUsersPositions(currentRoom.users);

    isCurrentUserSpectator = ref.watch(currentRoomProvider).whenOrNull(
              data: (currentRoom) {
                final currentUser = ref.read(currentUserProvider).requireValue;
                if (currentUser == null) {
                  return false;
                }

                final matchingUser = currentRoom!.users.firstWhereOrNull(
                  (user) => user.firebaseUser.id == currentUser.id,
                );

                return matchingUser?.roomUser.isSpectator;
              },
              loading: () => false,
              error: (error, stackTrace) => false,
            ) ??
        false; // Default to false if the provider isn't ready

    isSessionVoting = currentRoom.session?.currentState == SessionState.voting;

    return Column(
      children: <Widget>[
        // Top row
        SizedBox(
          height:
              (height - appBarHeight! - (isSessionVoting ? heightVotingUi : 0))
                  .toDouble(),
          child: Column(
            children: [
              Expanded(
                flex: isSessionVoting ? heightVotingUISides : heightSides,
                child: Row(
                  children: [
                    TableGridItem(flex: widthSides),
                    Expanded(
                      flex: tableWidth,
                      child: Row(children: topRow),
                    ),
                    TableGridItem(flex: widthSides),
                  ],
                ),
              ),
              // Left and right
              Expanded(
                flex: tableHeight,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: widthSides,
                      child: Column(children: leftColumn),
                    ),
                    const TableItem(flex: tableWidth),
                    Expanded(
                        flex: widthSides, child: Column(children: rightColumn)),
                  ],
                ),
              ),
              Expanded(
                flex: isSessionVoting ? heightVotingUISides : heightSides,
                child: Row(
                  children: [
                    TableGridItem(flex: widthSides),
                    Expanded(
                      flex: tableWidth,
                      child: Row(children: bottomRow),
                    ),
                    TableGridItem(flex: widthSides),
                  ],
                ),
              ),
              // If user is spectating, build a spectating message
              if (isCurrentUserSpectator) const SpectatingMessage(),
            ],
          ),
        ),
        // If session is voting and user is not spectating, display the voting UI
        if (!isCurrentUserSpectator && isSessionVoting)
          SizedBox(
            height: heightVotingUi.toDouble(),
            child: const VotingUI(height: heightVotingUi),
          ),
      ],
    );
  }

  void _buildRoomUsersPositions(List<CombinedUser> users) {
    final List<CombinedUser> usersToSpread = List.from(users);

    for (List<CombinedUser> row in grid) {
      row.clear();
    }

    final currentUser = usersToSpread.firstWhereOrNull((user) =>
        user.roomUser.id == ref.read(currentUserProvider).requireValue?.id);
    if (currentUser == null) {
      return;
    }
    usersToSpread.remove(currentUser);
    usersToSpread.insert(0, currentUser);
    grid[0].add(currentUser);

    if (usersToSpread.length >= 2) grid[1].add(usersToSpread[1]);
    if (usersToSpread.length >= 3) grid[2].add(usersToSpread[2]);
    if (usersToSpread.length >= 4) grid[3].add(usersToSpread[3]);
    if (usersToSpread.length >= 5) grid[0].add(usersToSpread[4]);
    if (usersToSpread.length >= 6) grid[1].add(usersToSpread[5]);
    if (usersToSpread.length >= 7) grid[0].add(usersToSpread[6]);
    if (usersToSpread.length >= 8) grid[1].add(usersToSpread[7]);
    if (usersToSpread.length >= 9) grid[0].add(usersToSpread[8]);
    if (usersToSpread.length >= 10) grid[1].add(usersToSpread[9]);
    if (usersToSpread.length >= 11) {
      grid[2].add(usersToSpread[10]);
    }
    if (usersToSpread.length >= 12) grid[3].add(usersToSpread[11]);
    if (usersToSpread.length >= 13) {
      grid[2].add(usersToSpread[12]);
    }
    if (usersToSpread.length == 14) grid[3].add(usersToSpread[13]);

    setState(() {
      topRow = _buildTopRow(usersToSpread);
      bottomRow = _buildBottomRow(usersToSpread);
      leftColumn = _buildLeftColumn(usersToSpread);
      rightColumn = _buildRightColumn(usersToSpread);
    });
  }

  List<Widget> _buildTopRow(List<CombinedUser> users) {
    final List<Widget> row = [];
    if (users.length < 2) {
      row.add(const FeelingLonelyMessage());
    } else {
      for (CombinedUser user in grid[1]) {
        row.add(TableGridItem(
          user: user,
        ));
      }
    }
    return row;
  }

  List<Widget> _buildBottomRow(List<CombinedUser> users) {
    final List<Widget> row = [];
    for (CombinedUser user in grid[0]) {
      row.add(TableGridItem(
        user: user,
        orientation: PlayerOnTableOrientation.bottom,
      ));
    }
    return row;
  }

  List<Widget> _buildLeftColumn(List<CombinedUser> users) {
    final List<Widget> column = [];
    for (CombinedUser user in grid[2]) {
      column.add(TableGridItem(
        user: user,
        orientation: PlayerOnTableOrientation.left,
      ));
    }
    return column;
  }

  List<Widget> _buildRightColumn(List<CombinedUser> users) {
    final List<Widget> column = [];
    for (CombinedUser user in grid[3]) {
      column.add(TableGridItem(
        user: user,
        orientation: PlayerOnTableOrientation.right,
      ));
    }
    return column;
  }
}
