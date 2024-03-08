import 'package:flutter/material.dart';

class LabelLarge extends StatelessWidget {
  final String text;
  final Color? color;

  const LabelLarge(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
    );
  }
}
