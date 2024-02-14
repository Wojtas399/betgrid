import 'package:auto_route/auto_route.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/grand_prix.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import '../../config/router/app_router.dart';
import '../../riverpod_provider/grand_prix_bet_status_provider.dart';
import '../../service/formatter_service.dart';

class HomeGrandPrixItem extends StatelessWidget {
  final int roundNumber;
  final GrandPrix grandPrix;

  const HomeGrandPrixItem({
    super.key,
    required this.roundNumber,
    required this.grandPrix,
  });

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
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFe6bcbc),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: CountryFlag.fromCountryCode(
                    grandPrix.countryAlpha2Code,
                    height: 48,
                    width: 62,
                    borderRadius: 8,
                  ),
                ),
                const GapHorizontal16(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleMedium(
                        grandPrix.name,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      const GapVertical4(),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            BodyMedium(
                              'Runda $roundNumber',
                              color: Colors.white.withOpacity(0.75),
                              fontWeight: FontWeight.bold,
                            ),
                            VerticalDivider(
                              color: Colors.white.withOpacity(0.25),
                            ),
                            BodyMedium(
                              '${grandPrix.startDate.toDayAndMonthName()} - ${grandPrix.endDate.toDayAndMonthName()}',
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
        GrandPrixBetStatus.completed => Icons.check_circle,
        _ => Icons.circle_outlined,
      },
      color: switch (betStatus.value) {
        GrandPrixBetStatus.pending => Colors.white,
        GrandPrixBetStatus.inProgress => Colors.amberAccent,
        GrandPrixBetStatus.completed => const Color(0xFF6BD65F),
        _ => Colors.white,
      },
    );
  }
}
