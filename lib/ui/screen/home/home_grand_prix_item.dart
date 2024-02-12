import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../model/grand_prix.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import '../../config/router/app_router.dart';
import '../../service/formatter_service.dart';

class HomeGrandPrixItem extends StatelessWidget {
  final GrandPrix grandPrix;

  const HomeGrandPrixItem({super.key, required this.grandPrix});

  void _onPressed(BuildContext context) {
    context.navigateTo(GrandPrixBetRoute(
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
        child: InkWell(
          onTap: () => _onPressed(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleMedium(
                      grandPrix.name,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    const GapVertical4(),
                    BodyMedium(
                      '${grandPrix.startDate.toDayAndMonth()} - ${grandPrix.endDate.toDayAndMonth()}',
                      color: colorScheme.outline.withOpacity(0.75),
                    ),
                  ],
                ),
                const Icon(Icons.circle_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
