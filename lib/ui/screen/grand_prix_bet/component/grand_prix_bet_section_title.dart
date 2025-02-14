import 'package:flutter/material.dart';

import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';

class GrandPrixBetSectionTitle extends StatelessWidget {
  final String title;
  final double? points;

  const GrandPrixBetSectionTitle({super.key, required this.title, this.points});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TitleLarge(title),
        if (points != null)
          TitleLarge(
            ' ($points pkt.)',
            color: context.colorScheme.primary.withValues(alpha: 0.6),
          ),
      ],
    );
  }
}
