import 'package:flutter/material.dart';

import '../../../../model/grand_prix.dart';
import '../../../service/formatter_service.dart';

class GrandPrixItem extends StatelessWidget {
  final GrandPrix grandPrix;

  const GrandPrixItem({super.key, required this.grandPrix});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        grandPrix.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        '${grandPrix.startDate.toDayAndMonth()} - ${grandPrix.endDate.toDayAndMonth()}',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
      children: const [
        //TODO
      ],
    );
  }
}
