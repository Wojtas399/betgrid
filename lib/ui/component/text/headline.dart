import 'package:flutter/material.dart';

class HeadlineMedium extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;

  const HeadlineMedium(
    this.text, {
    super.key,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: fontWeight,
            color: color,
          ),
    );
  }
}
