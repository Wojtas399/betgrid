import 'package:flutter/material.dart';

import '../../../component/custom_card_component.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback? onPressed;

  const StatsCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) => CustomCard(
    onPressed: onPressed,
    child: Column(
      spacing: 16,
      children: [
        Row(
          spacing: 16,
          children: [_Icon(icon), Flexible(child: TitleMedium(title))],
        ),
        child,
      ],
    ),
  );
}

class _Icon extends StatelessWidget {
  const _Icon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.all(8),
    child: Icon(icon, color: context.colorScheme.primary),
  );
}
