import 'package:flutter/material.dart';

class BodyMedium extends StatelessWidget {
  final String text;
  final Color? color;

  const BodyMedium(
    this.text, {
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
          ),
    );
  }
}
