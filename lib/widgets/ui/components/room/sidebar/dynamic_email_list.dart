import 'package:flutter/material.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/widgets/ui/components/general/text_input_field.dart';
import 'package:sprintinio/styles/colors.dart';

class DynamicEmailList extends StatefulWidget {
  final Function(List<String>) onEmailsChanged;
  final List<String> initialEmails;

  const DynamicEmailList({
    super.key,
    required this.onEmailsChanged,
    this.initialEmails = const [],
  });

  @override
  DynamicEmailListState createState() => DynamicEmailListState();
}

class DynamicEmailListState extends State<DynamicEmailList> {
  final TextEditingController _controller = TextEditingController();
  final List<String> emails = [];
  final List<bool> _isValidEmail = [];
  bool _isInvalidEmailErrorVisible = false;

  @override
  void initState() {
    super.initState();
    emails.addAll(widget.initialEmails);
    _isValidEmail
        .addAll(List.generate(widget.initialEmails.length, (_) => true));
  }

  void _addEmail() {
    final email = _controller.text.trim();
    if (email.isNotEmpty) {
      if (_validateEmail(email)) {
        setState(() {
          emails.add(email);
          _isValidEmail.add(true);
          _controller.clear();
          _isInvalidEmailErrorVisible = false;
        });
        _notifyParent();
      } else {
        setState(() {
          _isInvalidEmailErrorVisible = true;
        });
      }
    }
  }

  void _removeEmail(int index) {
    setState(() {
      emails.removeAt(index);
      _isValidEmail.removeAt(index);
      _notifyParent();
    });
  }

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);
  }

  void _notifyParent() {
    widget.onEmailsChanged(emails); // Call the callback function
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInputField(
          controller: _controller,
          label: 'Add Users',
          placeholder: 'Enter email',
          onSubmitted: (_) => _addEmail(),
          iconVisible: true,
        ),
        if (_isInvalidEmailErrorVisible)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Invalid Email',
              style: TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: emails.map((email) {
            final index = emails.indexOf(email);
            return Chip(
              label: Text(
                email,
                style: TextStyles.smallPurple,
              ),
              onDeleted: () => _removeEmail(index),
              deleteIconColor: AppColors.purple,
              backgroundColor: const Color.fromRGBO(147, 38, 255, 0.1),
              deleteIcon: const Icon(Icons.close),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              side: BorderSide.none,
            );
          }).toList(),
        ),
      ],
    );
  }
}
