import 'package:flutter/material.dart';
import 'package:sprintinio/models/create_tickets_permission.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/styles/colors.dart';

class IssuesPermissionsDropdown extends StatefulWidget {
  final ManageIssuesPermission? initialValue;
  final ValueChanged<ManageIssuesPermission?> onChanged;

  const IssuesPermissionsDropdown({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  IssuesPermissionsDropdownState createState() =>
      IssuesPermissionsDropdownState();
}

class IssuesPermissionsDropdownState extends State<IssuesPermissionsDropdown> {
  bool _isHovering = false;
  ManageIssuesPermission? _selectedPermission;

  @override
  void initState() {
    super.initState();
    _selectedPermission =
        widget.initialValue ?? ManageIssuesPermission.onlyHost;
  }

  void _onEnter(PointerEvent event) {
    setState(() => _isHovering = true);
  }

  void _onExit(PointerEvent event) {
    setState(() => _isHovering = false);
  }

  void _onChanged(ManageIssuesPermission? value) {
    setState(() {
      _selectedPermission = value;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Who can manage Issues',
          style: TextStyles.smallGreyHover,
        ),
        const SizedBox(height: 5.0),
        MouseRegion(
          onEnter: _onEnter,
          onExit: _onExit,
          child: DropdownButtonFormField<ManageIssuesPermission>(
            value: _selectedPermission,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style:
                const TextStyle(color: AppColors.black, fontFamily: 'Aeonic'),
            items: ManageIssuesPermission.values
                .map<DropdownMenuItem<ManageIssuesPermission>>(
                    (ManageIssuesPermission permission) {
              return DropdownMenuItem<ManageIssuesPermission>(
                value: permission,
                child: Text(
                  permission.name,
                  style: TextStyles.smallBlack,
                ),
              );
            }).toList(),
            onChanged: (ManageIssuesPermission? value) => _onChanged(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: _isHovering ? AppColors.greyHover : AppColors.grey),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: _isHovering ? AppColors.greyHover : AppColors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
