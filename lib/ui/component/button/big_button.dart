import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const BigButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 325,
        height: 60,
        child: FilledButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      );
}
