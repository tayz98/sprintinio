import 'package:flutter/material.dart';
import 'package:sprintinio/styles/colors.dart';

class TextStyles {
  /// Button text styles for white text
  static const TextStyle smallWhite = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w100,
  );
  static const TextStyle mediumWhite = TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle largeWhite = TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  /// Button text styles for purple text
  static const TextStyle smallPurple = TextStyle(
    color: AppColors.purple,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle mediumPurple = TextStyle(
    color: AppColors.purple,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  /// Button text styles for grey text
  static const TextStyle smallGrey = TextStyle(
    color: AppColors.grey,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle smallGreyText = TextStyle(
    color: AppColors.greyText,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle smallGreyHover = TextStyle(
    fontSize: 16,
    color: AppColors.greyHover,
    fontFamily: 'Aeonic',
  );

  /// Button text styles for black text
  static const TextStyle smallLightBlack = TextStyle(
    color: AppColors.lightBlack,
    fontSize: 16,
  );
  static const TextStyle smallBlack = TextStyle(
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle mediumLightBlack = TextStyle(
    color: AppColors.lightBlack,
    fontSize: 20,
  );
  static const TextStyle largeBlack = TextStyle(
    color: AppColors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
}
