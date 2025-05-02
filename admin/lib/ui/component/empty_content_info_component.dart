import 'package:flutter/material.dart';

import '../extensions/build_context_extensions.dart';
import 'gap/gap_vertical.dart';
import 'padding_component.dart';
import 'text_component.dart';

class EmptyContentInfo extends StatelessWidget {
  final String title;
  final String message;

  const EmptyContentInfo({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) => Padding24(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TitleLarge(title, fontWeight: FontWeight.bold),
          const GapVertical16(),
          BodyMedium(
            message,
            textAlign: TextAlign.center,
            color: context.colorScheme.outline,
          ),
        ],
      ),
    ),
  );
}
