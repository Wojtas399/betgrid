import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../model/grand_prix.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import '../../config/router/app_router.dart';
import '../../extensions/build_context_extensions.dart';
import '../../service/formatter_service.dart';

class HomeGrandPrixItem extends StatelessWidget {
  final GrandPrix grandPrix;

  const HomeGrandPrixItem({super.key, required this.grandPrix});

  void _onQualificationsBetPressed(BuildContext context) {
    context.navigateTo(QualificationsBetRoute(
      grandPrixId: grandPrix.id,
    ));
  }

  void _onRaceBetPressed(BuildContext context) {
    context.navigateTo(RaceBetRoute(
      grandPrixId: grandPrix.id,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ExpansionTile(
          shape: const Border(),
          title: TitleMedium(
            grandPrix.name,
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          subtitle: BodyMedium(
            '${grandPrix.startDate.toDayAndMonth()} - ${grandPrix.endDate.toDayAndMonth()}',
            color: colorScheme.outline.withOpacity(0.75),
          ),
          children: [
            _BetSection(
              title: context.str.qualifications,
              onPressed: () => _onQualificationsBetPressed(context),
            ),
            _BetSection(
              title: context.str.race,
              onPressed: () => _onRaceBetPressed(context),
            ),
            _BetSection(
              title: context.str.other,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _BetSection extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _BetSection({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TitleMedium(title),
      trailing: const Icon(Icons.circle_outlined),
      onTap: onPressed,
    );
  }
}
