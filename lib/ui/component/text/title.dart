import 'package:flutter/material.dart';

class TitleMedium extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;

  const TitleMedium(
    this.text, {
    super.key,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: fontWeight,
            color: color,
          ),
    );
  }
}

class TitleLarge extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final Color? color;

  const TitleLarge(
    this.text, {
    super.key,
    this.textAlign,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: fontWeight,
            color: color,
          ),
      textAlign: textAlign,
    );
  }
}
