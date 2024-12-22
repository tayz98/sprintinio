import 'package:flutter/material.dart';
import 'package:sprintinio/styles/colors.dart';

class UserCircleAvatar extends StatelessWidget {
  final String url;
  final bool isCurrentUser;
  final bool isSpectator;

  const UserCircleAvatar(
      {super.key,
      required this.url,
      required this.isCurrentUser,
      required this.isSpectator});

  @override
  Widget build(BuildContext context) {
    if (isSpectator) {
      return CircleAvatar(
        backgroundColor: isCurrentUser ? AppColors.purple : null,
        radius: 24,
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: CircleAvatar(
            backgroundImage: AssetImage(url),
            radius: 22,
          ),
        ),
      );
    }
    return CircleAvatar(
      backgroundColor: isCurrentUser ? AppColors.purple : null,
      radius: 24,
      child: isCurrentUser
          ? CircleAvatar(backgroundImage: AssetImage(url), radius: 22)
          : CircleAvatar(
              radius: 22,
              child: Image.asset(url, fit: BoxFit.cover),
            ),
    );
  }
}
