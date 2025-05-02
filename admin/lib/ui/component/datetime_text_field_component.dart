import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_text_field_component.dart';

class DateTimeTextField extends StatefulWidget {
  final String label;
  final Function(DateTime)? onChanged;

  const DateTimeTextField({super.key, required this.label, this.onChanged});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DateTimeTextField> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _onTap() async {
    final DateTime? selectedDateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
    );
    if (selectedDateTime != null) {
      _controller.text = DateFormat.yMMMd().format(selectedDateTime);
      if (widget.onChanged != null) widget.onChanged!(selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) => CustomTextField(
    label: widget.label,
    controller: _controller,
    onTap: _onTap,
  );
}
