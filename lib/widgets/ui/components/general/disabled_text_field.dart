import 'package:flutter/material.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/styles/colors.dart';

class DisabledTextField extends StatefulWidget {
  final String label;
  final String text;
  final void Function()? onCopy;

  const DisabledTextField({
    super.key,
    required this.label,
    required this.text,
    this.onCopy,
  });

  @override
  State<DisabledTextField> createState() => _DisabledTextFieldState();
}

class _DisabledTextFieldState extends State<DisabledTextField> {
  bool _isHovering = false;

  void _onHoverEnter(PointerEvent event) {
    setState(() {
      _isHovering = true;
    });
  }

  void _onHoverExit(PointerEvent event) {
    setState(() {
      _isHovering = false;
    });
  }

  OutlineInputBorder _getBorder(Color borderColor) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor),
    );
  }

  Color get _borderColor {
    if (_isHovering) {
      return AppColors.greyHover;
    } else {
      return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyles.smallLightBlack,
        ),
        const SizedBox(height: 8.0),
        MouseRegion(
          onEnter: _onHoverEnter,
          onExit: _onHoverExit,
          child: TextField(
            controller: TextEditingController(text: widget.text),
            readOnly: true,
            style: const TextStyle(fontSize: 16.0),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              border: _getBorder(_borderColor),
              enabledBorder: _getBorder(_borderColor),
              focusedBorder: _getBorder(_borderColor),
              contentPadding: const EdgeInsets.fromLTRB(20, 14, 40, 14),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(4),
                child: InkWell(
                  onTap: widget.onCopy,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: const Icon(
                      Icons.copy,
                      color: AppColors.white,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
