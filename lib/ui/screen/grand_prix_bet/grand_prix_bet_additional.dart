import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../component/text/body.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/bet_points/bonus_bet_points_provider.dart';
import '../../provider/bet_points/safety_car_and_red_flag_points_provider.dart';
import '../../provider/grand_prix_bet/grand_prix_bet_provider.dart';
import '../../provider/grand_prix_results_provider.dart';
import 'grand_prix_bet_driver_description.dart';
import 'grand_prix_bet_row.dart';
import 'grand_prix_bet_table.dart';
import 'grand_prix_points_summary.dart';

class GrandPrixBetAdditional extends ConsumerWidget {
  const GrandPrixBetAdditional({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String?>? dnfDriverIds = ref.watch(
      grandPrixBetProvider.select(
        (state) => state.value?.dnfDriverIds,
      ),
    );
    final bool? willBeSafetyCar = ref.watch(
      grandPrixBetProvider.select(
        (state) => state.value?.willBeSafetyCar,
      ),
    );
    final bool? willBeRedFlag = ref.watch(
      grandPrixBetProvider.select(
        (state) => state.value?.willBeRedFlag,
      ),
    );
    final List<String>? resultsDnfDriverIds = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.raceResults?.dnfDriverIds,
      ),
    );
    final bool? resultsWasThereSafetyCar = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.raceResults?.wasThereSafetyCar,
      ),
    );
    final bool? resultsWasThereRedFlag = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.raceResults?.wasThereRedFlag,
      ),
    );
    final pointsDetails = ref.watch(bonusBetPointsProvider);

    return Column(
      children: [
        GrandPrixBetTable(
          rows: [
            GrandPrixBetRow.build(
              context: context,
              label: 'DNF',
              betChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...?dnfDriverIds?.map(
                    (e) => DriverDescription(driverId: e),
                  ),
                ],
              ),
              resultsChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (resultsDnfDriverIds?.isNotEmpty == true)
                    ...?resultsDnfDriverIds?.map(
                      (e) => DriverDescription(driverId: e),
                    ),
                  if (resultsDnfDriverIds?.isEmpty == true)
                    BodyMedium(
                      context.str.lack,
                      fontWeight: FontWeight.bold,
                    ),
                ],
              ),
              points: pointsDetails.value?.dnfDriversPoints,
            ),
            GrandPrixBetRow.build(
              context: context,
              label: 'SC',
              betChild: Text(willBeSafetyCar?.toI8nString(context) ?? '--'),
              resultsChild: Text(
                resultsWasThereSafetyCar?.toI8nString(context) ?? '--',
              ),
              points: ref.watch(
                safetyCarAndRedFlagPointsProvider(
                  resultsVal: resultsWasThereSafetyCar,
                  betVal: willBeSafetyCar,
                ),
              ),
            ),
            GrandPrixBetRow.build(
              context: context,
              label: 'RF',
              betChild: Text(willBeRedFlag?.toI8nString(context) ?? '--'),
              resultsChild: Text(
                resultsWasThereRedFlag?.toI8nString(context) ?? '--',
              ),
              points: ref.watch(
                safetyCarAndRedFlagPointsProvider(
                  resultsVal: resultsWasThereRedFlag,
                  betVal: willBeRedFlag,
                ),
              ),
            ),
          ],
        ),
        GrandPrixBetPointsSummary(
          details: [
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetDNF,
              value: pointsDetails.value?.dnfDriversPoints.toString(),
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetDNFMultiplier,
              value:
                  pointsDetails.value?.dnfDriversPointsMultiplier?.toString() ??
                      context.str.lack,
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetOther,
              value: pointsDetails.value?.safetyCarAndRedFlagPoints.toString(),
            ),
          ],
          totalPoints: pointsDetails.value?.totalPoints ?? 0,
        ),
      ],
    );
  }
}

extension _BoolExtensions on bool {
  String toI8nString(BuildContext context) => switch (this) {
        true => context.str.yes,
        false => context.str.no,
      };
}
