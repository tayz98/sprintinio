import 'package:flutter/material.dart';
import 'package:sprintinio/models/combined_user.dart';
import 'package:sprintinio/models/player_on_table_orientation.dart';
import 'package:sprintinio/widgets/ui/components/room/table/user_table_profile.dart';

class TableGridItem extends StatelessWidget {
  final int flex;
  final double aspectRation;
  final CombinedUser? user;
  final Color color;
  final PlayerOnTableOrientation orientation;

  const TableGridItem(
      {super.key,
      this.flex = 1,
      this.aspectRation = 1.0,
      this.color = Colors.transparent,
      this.orientation = PlayerOnTableOrientation.top,
      this.user});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
          color: color,
          margin: const EdgeInsets.all(2),
          height: double.infinity,
          child: user != null
              ? UserTableProfile(
                  user: user!,
                  orientation: orientation,
                )
              : null),
    );
  }
}
