import 'package:flutter/material.dart';

import 'colors.dart';

/// Class for all button styles.
class ButtonStyles {
  /// Button style for purple button
  static ButtonStyle purpleButtonStyle = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return AppColors.purplePressed;
      } else if (states.contains(MaterialState.hovered)) {
        return AppColors.purpleHover;
      }
      return AppColors.purple;
    }),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    fixedSize: MaterialStateProperty.all<Size>(
      const Size(double.infinity, 50),
    ),
  );

  /// Button style for white button
  static ButtonStyle whiteButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.white;
        } else if (states.contains(MaterialState.hovered)) {
          return AppColors.white;
        }
        return AppColors.white;
      },
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    // The following line will ensure the width is set via the SizedBox
    fixedSize: MaterialStateProperty.all<Size?>(null),
  );

  /// Button style for grey button
  static ButtonStyle greyButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return AppColors.greyHover;
          }
          if (states.contains(MaterialState.pressed)) {
            return AppColors.greyPressed;
          }
          return AppColors.grey;
        },
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      fixedSize: MaterialStateProperty.all<Size>(
        const Size(double.infinity, 50), // Width and height
      ));

  /// Button style for text link button
  static ButtonStyle buildTextLinkButtonStyle(double size) {
    return ButtonStyle(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      padding:
          MaterialStateProperty.all(EdgeInsets.zero), // Remove default padding
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return AppColors.purplePressed;
          } else if (states.contains(MaterialState.hovered)) {
            return AppColors.purpleHover;
          }
          return AppColors.purple;
        },
      ),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return TextStyle(
              color: AppColors.purplePressed,
              fontSize: size,
              fontWeight: FontWeight.bold,
            );
          } else if (states.contains(MaterialState.hovered)) {
            return TextStyle(
              color: AppColors.purpleHover,
              fontSize: size,
              fontWeight: FontWeight.bold,
            );
          }
          return TextStyle(
            color: AppColors.purple,
            fontSize: size,
            fontWeight: FontWeight.bold,
          );
        },
      ),
    );
  }
}
