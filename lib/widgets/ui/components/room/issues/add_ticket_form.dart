import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';
import 'package:sprintinio/widgets/ui/components/general/text_input_field.dart';

class AddTicketForm extends ConsumerStatefulWidget {
  final VoidCallback onSubmit;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController linkController;

  const AddTicketForm({
    super.key,
    required this.onSubmit,
    required this.titleController,
    required this.descriptionController,
    required this.linkController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTicketFormState();
}

class _AddTicketFormState extends ConsumerState<AddTicketForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInputField(
          placeholder: 'Issue title...',
          controller: widget.titleController,
          label: 'Title',
        ),
        const SizedBox(height: 8.0),
        TextInputField(
          placeholder: 'Short description...',
          controller: widget.descriptionController,
          label: 'Description (Optional)',
          maxLines: 5,
        ),
        const SizedBox(height: 8.0),
        TextInputField(
          placeholder: 'Link...',
          controller: widget.linkController,
          textInputAction: TextInputAction.done,
          label: 'Link (Optional)',
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          child: CustomPurpleButton(
            text: 'Add Issue',
            onPressed: widget.onSubmit,
          ),
        ),
      ],
    );
  }
}
