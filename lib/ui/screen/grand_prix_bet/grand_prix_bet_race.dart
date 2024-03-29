import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../dependency_injection.dart';
import '../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_method_providers.dart';
import '../../../model/grand_prix_bet_points.dart';
import '../../component/text_component.dart';
import '../../config/theme/custom_colors.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/grand_prix_id_provider.dart';
import 'grand_prix_bet_driver_description.dart';
import 'grand_prix_bet_row.dart';
import 'grand_prix_bet_table.dart';
import 'grand_prix_points_summary.dart';
import 'provider/grand_prix_bet_provider.dart';
import 'provider/player_id_provider.dart';
import 'provider/results_for_grand_prix_provider.dart';

class GrandPrixBetRace extends ConsumerWidget {
  const GrandPrixBetRace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grandPrixBet = ref.watch(grandPrixBetProvider);
    final raceResults = ref.watch(
      resultsForGrandPrixProvider.select(
        (state) => state.value?.raceResults,
      ),
    );
    final String? grandPrixId = ref.watch(grandPrixIdProvider);
    final String? playerId = ref.watch(playerIdProvider);
    RaceBetPoints? racePointsDetails;
    if (grandPrixId != null && playerId != null) {
      racePointsDetails = ref.watch(
        grandPrixBetPointsProvider(
          grandPrixId: grandPrixId,
          playerId: playerId,
        ).select(
          (state) => state.value?.raceBetPoints,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrandPrixBetTable(
          rows: [
            ...List.generate(
              5,
              (index) {
                final String? betDriverId = switch (index) {
                  0 => grandPrixBet.value?.p1DriverId,
                  1 => grandPrixBet.value?.p2DriverId,
                  2 => grandPrixBet.value?.p3DriverId,
                  3 => grandPrixBet.value?.p10DriverId,
                  4 => grandPrixBet.value?.fastestLapDriverId,
                  _ => null,
                };
                final String? resultsDriverId = switch (index) {
                  0 => raceResults?.p1DriverId,
                  1 => raceResults?.p2DriverId,
                  2 => raceResults?.p3DriverId,
                  3 => raceResults?.p10DriverId,
                  4 => raceResults?.fastestLapDriverId,
                  _ => null,
                };

                return GrandPrixBetRow(
                  label: switch (index) {
                    0 => 'P1',
                    1 => 'P2',
                    2 => 'P3',
                    3 => 'P10',
                    4 => 'FL',
                    _ => '',
                  },
                  labelBackgroundColor: switch (index) {
                    0 => getIt<CustomColors>().gold,
                    1 => getIt<CustomColors>().silver,
                    2 => getIt<CustomColors>().brown,
                    4 => getIt<CustomColors>().violet,
                    _ => null,
                  },
                  betChild: DriverDescription(driverId: betDriverId),
                  resultsChild: DriverDescription(driverId: resultsDriverId),
                  points: switch (index) {
                    0 => racePointsDetails?.p1Points,
                    1 => racePointsDetails?.p2Points,
                    2 => racePointsDetails?.p3Points,
                    3 => racePointsDetails?.p10Points,
                    4 => racePointsDetails?.fastestLapPoints,
                    _ => null,
                  },
                );
              },
            ),
            GrandPrixBetRow(
              label: 'DNF',
              betChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...?grandPrixBet.value?.dnfDriverIds.map(
                    (e) => DriverDescription(driverId: e),
                  ),
                ],
              ),
              resultsChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (raceResults?.dnfDriverIds.isNotEmpty == true)
                    ...?raceResults?.dnfDriverIds.map(
                      (e) => DriverDescription(driverId: e),
                    ),
                  if (raceResults?.dnfDriverIds.isEmpty == true)
                    BodyMedium(
                      context.str.lack,
                      fontWeight: FontWeight.bold,
                    ),
                ],
              ),
              points: racePointsDetails?.dnfPoints,
            ),
            GrandPrixBetRow(
              label: 'SC',
              betChild: Text(
                grandPrixBet.value?.willBeSafetyCar?.toI8nString(context) ??
                    '--',
              ),
              resultsChild: Text(
                raceResults?.wasThereSafetyCar.toI8nString(context) ?? '--',
              ),
              points: racePointsDetails?.safetyCarPoints,
            ),
            GrandPrixBetRow(
              label: 'RF',
              betChild: Text(
                grandPrixBet.value?.willBeRedFlag?.toI8nString(context) ?? '--',
              ),
              resultsChild: Text(
                raceResults?.wasThereRedFlag.toI8nString(context) ?? '--',
              ),
              points: racePointsDetails?.redFlagPoints,
            ),
          ],
        ),
        GrandPrixBetPointsSummary(
          details: [
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetPositions,
              value: '${racePointsDetails?.podiumAndP10Points ?? '--'}',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetPositionsMultiplier,
              value:
                  racePointsDetails?.podiumAndP10Multiplier?.toString() ?? '--',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetFastestLap,
              value: '${racePointsDetails?.fastestLapPoints ?? '--'}',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetDNF,
              value: '${racePointsDetails?.dnfPoints ?? '--'}',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetDNFMultiplier,
              value: racePointsDetails?.dnfMultiplier?.toString() ?? '--',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetOther,
              value: racePointsDetails != null
                  ? '${racePointsDetails.safetyCarPoints + racePointsDetails.redFlagPoints}'
                  : '--',
            ),
          ],
          totalPoints: racePointsDetails?.totalPoints,
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
