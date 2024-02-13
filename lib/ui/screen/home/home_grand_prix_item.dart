import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/grand_prix.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import '../../config/router/app_router.dart';
import '../../riverpod_provider/grand_prix_bet_status_provider.dart';
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    const GapVertical4(),
                    BodyMedium(
                      '${grandPrix.startDate.toDayAndMonth()} - ${grandPrix.endDate.toDayAndMonth()}',
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ],
                ),
                _BetStatus(grandPrixId: grandPrix.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BetStatus extends ConsumerWidget {
  final String grandPrixId;

  const _BetStatus({required this.grandPrixId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GrandPrixBetStatus?> betStatus = ref.watch(
      grandPrixBetStatusProvider(grandPrixId),
    );

    return Icon(
      switch (betStatus.value) {
        GrandPrixBetStatus.pending => Icons.circle_outlined,
        GrandPrixBetStatus.inProgress => Icons.timelapse,
        GrandPrixBetStatus.completed => Icons.check_circle_outline,
        _ => Icons.circle_outlined,
      },
      color: switch (betStatus.value) {
        GrandPrixBetStatus.pending => Colors.white,
        GrandPrixBetStatus.inProgress => Colors.amberAccent,
        GrandPrixBetStatus.completed => Colors.lightGreen,
        _ => Colors.white,
      },
    );
  }
}
