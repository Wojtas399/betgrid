import 'package:flutter/material.dart';

import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';

class SeasonGrandPrixBetEditorBooleanField extends StatelessWidget {
  final bool? selectedValue;
  final Function(bool) onValueSelected;

  const SeasonGrandPrixBetEditorBooleanField({
    super.key,
    this.selectedValue,
    required this.onValueSelected,
  });

  void _onYesChanged(bool? isChecked) {
    if (isChecked == true &&
        (selectedValue == null || selectedValue == false)) {
      onValueSelected(true);
    }
  }

  void _onNoChanged(bool? isChecked) {
    if (isChecked == true && (selectedValue == null || selectedValue == true)) {
      onValueSelected(false);
    }
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _CheckboxWithLabel(
          label: context.str.yes,
          isChecked: selectedValue == true,
          onChanged: _onYesChanged,
        ),
      ),
      Expanded(
        child: _CheckboxWithLabel(
          label: context.str.no,
          isChecked: selectedValue == false,
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
      Checkbox(value: isChecked, onChanged: onChanged),
    ],
  );
}
