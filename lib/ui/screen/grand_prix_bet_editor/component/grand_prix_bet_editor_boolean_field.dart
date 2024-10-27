import 'package:flutter/material.dart';

import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';

class GrandPrixBetEditorBooleanField extends StatefulWidget {
  final bool? initialValue;
  final Function(bool) onChanged;

  const GrandPrixBetEditorBooleanField({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<GrandPrixBetEditorBooleanField> {
  bool? _selectedOption;

  @override
  void initState() {
    _selectedOption = widget.initialValue;
    super.initState();
  }

  void _onYesChanged(bool? isChecked) {
    if (isChecked == true &&
        (_selectedOption == null || _selectedOption == false)) {
      setState(() {
        _selectedOption = true;
      });
      widget.onChanged(true);
    }
  }

  void _onNoChanged(bool? isChecked) {
    if (isChecked == true &&
        (_selectedOption == null || _selectedOption == true)) {
      setState(() {
        _selectedOption = false;
      });
      widget.onChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: _CheckboxWithLabel(
              label: context.str.yes,
              isChecked: _selectedOption == true,
              onChanged: _onYesChanged,
            ),
          ),
          Expanded(
            child: _CheckboxWithLabel(
              label: context.str.no,
              isChecked: _selectedOption == false,
              onChanged: _onNoChanged,
            ),
          ),
        ],
      );
}

class _CheckboxWithLabel extends StatelessWidget {
  final String label;
  final bool isChecked;
  final Function(bool?) onChanged;

  const _CheckboxWithLabel({
    required this.label,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          BodyMedium(label),
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
          ),
        ],
      );
}
