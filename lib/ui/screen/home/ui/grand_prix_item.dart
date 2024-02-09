import 'package:flutter/material.dart';

import '../../../../model/grand_prix.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/formatter_service.dart';

class GrandPrixItem extends StatelessWidget {
  final GrandPrix grandPrix;

  const GrandPrixItem({super.key, required this.grandPrix});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ExpansionTile(
          shape: const Border(),
          title: Text(
            grandPrix.name,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${grandPrix.startDate.toDayAndMonth()} - ${grandPrix.endDate.toDayAndMonth()}',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline.withOpacity(0.75),
            ),
          ),
          children: [
            _BetSection(title: context.str.qualifications),
            _BetSection(title: context.str.race),
            _BetSection(title: context.str.other),
          ],
        ),
      ),
    );
  }
}

class _BetSection extends StatelessWidget {
  final String title;

  const _BetSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: const Icon(Icons.circle_outlined),
      onTap: () {
        //TODO
      },
    );
  }
}
