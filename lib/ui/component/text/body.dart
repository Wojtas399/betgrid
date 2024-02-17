import 'package:flutter/material.dart';

class BodyMedium extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  const BodyMedium(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
      textAlign: textAlign,
    );
  }
}
