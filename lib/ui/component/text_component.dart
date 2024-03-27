import 'package:flutter/material.dart';

enum _TextStyleType {
  labelMedium,
  labelLarge,
  bodyMedium,
  bodyLarge,
  titleSmall,
  titleMedium,
  displayLarge,
  headlineMedium,
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
      _TextStyleType.labelMedium => textTheme.labelMedium,
      _TextStyleType.labelLarge => textTheme.labelLarge,
      _TextStyleType.bodyMedium => textTheme.bodyMedium,
      _TextStyleType.bodyLarge => textTheme.bodyLarge,
      _TextStyleType.titleSmall => textTheme.titleSmall,
      _TextStyleType.titleMedium => textTheme.titleMedium,
      _TextStyleType.displayLarge => textTheme.displayLarge,
      _TextStyleType.headlineMedium => textTheme.headlineMedium,
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

class LabelMedium extends _TextComponent {
  const LabelMedium(
    super.data, {
    super.key,
    super.color,
    super.fontWeight,
  }) : super(textStyleType: _TextStyleType.labelMedium);
}

class LabelLarge extends _TextComponent {
  const LabelLarge(
    super.data, {
    super.key,
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

class BodyLarge extends _TextComponent {
  const BodyLarge(
    super.data, {
    super.key,
    super.textAlign,
    super.fontWeight,
    super.color,
  }) : super(textStyleType: _TextStyleType.bodyLarge);
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

class DisplayLarge extends _TextComponent {
  const DisplayLarge(
    super.data, {
    super.key,
    super.fontWeight,
    super.color,
  }) : super(textStyleType: _TextStyleType.displayLarge);
}

class HeadlineMedium extends _TextComponent {
  const HeadlineMedium(
    super.data, {
    super.key,
    super.fontWeight,
    super.color,
  }) : super(textStyleType: _TextStyleType.headlineMedium);
}
