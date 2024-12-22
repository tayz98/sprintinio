import 'package:flutter/material.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/util/voting_systems.dart';
import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/styles/colors.dart';

class VotingSystemDropdown extends StatefulWidget {
  final VotingSystem? initialValue;
  final ValueChanged<VotingSystem> onChanged;
  final bool isDisabled;

  const VotingSystemDropdown({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.isDisabled = false, // Default value for isDisabled is false
  });

  @override
  VotingSystemDropdownState createState() => VotingSystemDropdownState();
}

class VotingSystemDropdownState extends State<VotingSystemDropdown> {
  bool isHovering = false;
  late VotingSystem? selectedVotingSystem;

  @override
  void initState() {
    super.initState();
    selectedVotingSystem = widget.initialValue ??
        VotingSystems.options
            .first; // Initialize with the initial value or the first option
  }

  void _onEnter(PointerEvent event) {
    if (!widget.isDisabled) {
      setState(() => isHovering = true);
    }
  }

  void _onExit(PointerEvent event) {
    if (!widget.isDisabled) {
      setState(() => isHovering = false);
    }
  }

  void _onChanged(VotingSystem value) {
    setState(() {
      selectedVotingSystem = value;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voting System',
          style: TextStyles.smallGreyHover,
        ),
        const SizedBox(height: 5.0),
        MouseRegion(
          onEnter: _onEnter,
          onExit: _onExit,
          child: DropdownButtonFormField<VotingSystem>(
            value: selectedVotingSystem,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: TextStyles.smallBlack,
            items: VotingSystems.options
                .map<DropdownMenuItem<VotingSystem>>((VotingSystem system) {
              return DropdownMenuItem<VotingSystem>(
                value: system,
                child: Text(
                  system.name,
                  style: TextStyles.smallBlack,
                ),
              );
            }).toList(),
            onChanged: widget.isDisabled
                ? null
                : (VotingSystem? value) => _onChanged(value!),
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.isDisabled ? AppColors.grey : AppColors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.isDisabled
                        ? AppColors.grey
                        : (isHovering ? AppColors.greyHover : AppColors.grey)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.isDisabled
                        ? AppColors.grey
                        : (isHovering ? AppColors.greyHover : AppColors.grey)),
              ),
            ),
            dropdownColor: widget.isDisabled ? AppColors.grey : null,
          ),
        ),
      ],
    );
  }
}
