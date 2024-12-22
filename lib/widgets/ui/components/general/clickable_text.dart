import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sprintinio/styles/colors.dart';

class ClickableText extends StatefulWidget {
  final String routeName;
  final String text;
  final TextStyle? style;

  const ClickableText({
    super.key,
    required this.routeName,
    required this.text,
    this.style,
  });

  @override
  ClickableTextState createState() => ClickableTextState();
}

class ClickableTextState extends State<ClickableText> {
  late TextStyle _normalStyle;
  late TextStyle _hoverStyle;
  late TextStyle _activeStyle;
  TextStyle _currentStyle;

  ClickableTextState() : _currentStyle = const TextStyle();

  @override
  void initState() {
    super.initState();
    _normalStyle = widget.style ??
        const TextStyle(color: AppColors.purple); // Normal color
    _hoverStyle =
        _normalStyle.copyWith(color: AppColors.purpleHover); // Hover color
    _activeStyle =
        _normalStyle.copyWith(color: AppColors.purplePressed); // Click color
    _currentStyle = _normalStyle;
  }

  void _updateStyle(TextStyle style) {
    setState(() {
      _currentStyle = style;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _updateStyle(_activeStyle),
      onTapUp: (_) {
        _updateStyle(_normalStyle);
        context.goNamed(widget.routeName);
      },
      onTapCancel: () => _updateStyle(_normalStyle),
      child: MouseRegion(
        onEnter: (_) => _updateStyle(_hoverStyle),
        onExit: (_) => _updateStyle(_normalStyle),
        child: Text(
          widget.text,
          style: _currentStyle,
        ),
      ),
    );
  }
}
