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
  bool? _state;

  @override
  void initState() {
    _state = widget.initialValue;
    super.initState();
  }

  void _onYesChanged(bool? isChecked) {
    if (isChecked == true) {
      setState(() {
        _state = true;
      });
    }
  }

  void _onNoChanged(bool? isChecked) {
    if (isChecked == true) {
      setState(() {
        _state = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: _CheckboxWithLabel(
              label: context.str.save,
              isChecked: _state == true,
              onChanged: _onYesChanged,
            ),
          ),
          Expanded(
            child: _CheckboxWithLabel(
              label: context.str.no,
              isChecked: _state == false,
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
          BodyMedium(context.str.yes),
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
          ),
        ],
      );
}
