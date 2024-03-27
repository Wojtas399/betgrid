import 'package:flutter/material.dart';

enum _TextStyleType {
  titleSmall,
  titleMedium,
  headlineSmall,
}

class _TextComponent extends StatelessWidget {
  final String data;
  final _TextStyleType textStyleType;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final Color? color;

  const _TextComponent(
    this.data, {
    super.key,
    required this.textStyleType,
    this.textAlign,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = switch (textStyleType) {
      _TextStyleType.titleSmall => textTheme.titleSmall,
      _TextStyleType.titleMedium => textTheme.titleMedium,
      _TextStyleType.headlineSmall => textTheme.headlineSmall,
    };

    return Text(
      data,
      style: textStyle?.copyWith(
        color: color,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
    );
  }
}

class TitleMedium extends _TextComponent {
  const TitleMedium(
    super.data, {
    super.key,
    super.textAlign,
    super.fontWeight,
    super.color,
  }) : super(textStyleType: _TextStyleType.titleMedium);
}

class TitleLarge extends _TextComponent {
  const TitleLarge(
    super.data, {
    super.key,
    super.textAlign,
    super.fontWeight,
    super.color,
  }) : super(textStyleType: _TextStyleType.titleSmall);
}
