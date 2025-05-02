import 'package:flutter/material.dart';

enum _TextStyleType { labelLarge, bodyMedium, titleMedium, titleLarge }

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
      _TextStyleType.labelLarge => textTheme.labelLarge,
      _TextStyleType.bodyMedium => textTheme.bodyMedium,
      _TextStyleType.titleMedium => textTheme.titleMedium,
      _TextStyleType.titleLarge => textTheme.titleLarge,
    };

    return Text(
      data,
      style: textStyle?.copyWith(color: color, fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }
}

class LabelLarge extends _TextComponent {
  const LabelLarge(
    super.data, {
    super.key,
    super.textAlign,
    super.fontWeight,
    super.color,
  }) : super(textStyleType: _TextStyleType.labelLarge);
}

class BodyMedium extends _TextComponent {
  const BodyMedium(
    super.data, {
    super.key,
    super.textAlign,
    super.fontWeight,
    super.color,
  }) : super(textStyleType: _TextStyleType.bodyMedium);
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
  const TitleLarge(super.data, {super.key, super.fontWeight})
    : super(textStyleType: _TextStyleType.titleLarge);
}
