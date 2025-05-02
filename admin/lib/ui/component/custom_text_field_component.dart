import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? error;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final Function(PointerDownEvent)? onTapOutside;

  const CustomTextField({
    super.key,
    required this.label,
    this.error,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      label: Text(label),
      errorText: error,
    ),
    controller: controller,
    focusNode: focusNode,
    keyboardType: keyboardType,
    onChanged: onChanged,
    onTap: onTap,
    onTapOutside: onTapOutside,
  );
}
