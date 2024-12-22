import 'package:flutter/material.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/styles/colors.dart';

class TextInputField extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String label;
  final Function? validator;
  final void Function(String)? onSubmitted;
  final int maxLines;
  final bool? iconVisible;
  final bool autoFocus;

  const TextInputField({
    super.key,
    this.placeholder,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    required this.label,
    this.validator,
    this.onSubmitted,
    this.maxLines = 1,
    this.iconVisible = false,
    this.autoFocus = false,
  });

  @override
  State<TextInputField> createState() => TextInputFieldState();
}

class TextInputFieldState extends State<TextInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);

    if (widget.autoFocus && widget.controller?.text == '') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

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
    if (_isFocused) {
      return AppColors.purple;
    } else if (_isHovering) {
      return AppColors.greyHover;
    } else {
      return AppColors.grey;
    }
  }

  Color get _labelColor {
    if (_isFocused) {
      return AppColors.purple;
    } else {
      return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyles.smallGreyHover),
        const SizedBox(height: 8),
        MouseRegion(
          onEnter: _onHoverEnter,
          onExit: _onHoverExit,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyles.smallGreyHover,
              labelStyle: TextStyle(color: _labelColor),
              enabledBorder: _getBorder(_borderColor),
              focusedBorder: _getBorder(_borderColor),
              border: _getBorder(_borderColor),
              suffixIcon: widget.iconVisible == true
                  ? Padding(
                      padding: const EdgeInsets.all(4),
                      child: InkWell(
                        onTap: () {
                          if (widget.onSubmitted != null &&
                              widget.controller != null) {
                            widget.onSubmitted!(widget.controller!.text);
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.purple,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: AppColors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
            validator: widget.validator != null
                ? (value) => widget.validator!(value) as String?
                : null,
            onFieldSubmitted: widget.onSubmitted,
            maxLines: widget.maxLines,
          ),
        ),
      ],
    );
  }
}
