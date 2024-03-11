import 'package:flutter/material.dart';

class DisplayLarge extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;

  const DisplayLarge(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
    );
  }
}
