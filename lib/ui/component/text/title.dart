import 'package:flutter/material.dart';

class TitleMedium extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;

  const TitleMedium(
    this.text, {
    super.key,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: fontWeight,
          ),
    );
  }
}

class TitleLarge extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  const TitleLarge(
    this.text, {
    super.key,
    this.textAlign,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: fontWeight,
          ),
      textAlign: textAlign,
    );
  }
}
