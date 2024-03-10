import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../dependency_injection.dart';
import '../../config/theme/custom_colors.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/grand_prix_bet/grand_prix_bet_provider.dart';
import '../../provider/grand_prix_results_provider.dart';
import 'grand_prix_bet_driver_description.dart';
import 'grand_prix_bet_row.dart';
import 'grand_prix_bet_table.dart';
import 'grand_prix_points_summary.dart';

class GrandPrixBetRace extends ConsumerWidget {
  const GrandPrixBetRace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? betP1DriverId = ref.watch(
      grandPrixBetProvider.select((state) => state.value?.p1DriverId),
    );
    final String? betP2DriverId = ref.watch(
      grandPrixBetProvider.select((state) => state.value?.p2DriverId),
    );
    final String? betP3DriverId = ref.watch(
      grandPrixBetProvider.select((state) => state.value?.p3DriverId),
    );
    final String? betP10DriverId = ref.watch(
      grandPrixBetProvider.select((state) => state.value?.p10DriverId),
    );
    final String? betFastestLapDriverId = ref.watch(
      grandPrixBetProvider.select(
        (state) => state.value?.fastestLapDriverId,
      ),
    );
    final String? resultsP1DriverId = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.raceResults?.p1DriverId,
      ),
    );
    final String? resultsP2DriverId = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.raceResults?.p2DriverId,
      ),
    );
    final String? resultsP3DriverId = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.raceResults?.p3DriverId,
      ),
    );
    final String? resultsP10DriverId = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.raceResults?.p10DriverId,
      ),
    );
    final String? resultsFastestLapDriverId = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.raceResults?.fastestLapDriverId,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrandPrixBetTable(
          rows: List.generate(
            5,
            (index) {
              final String? betDriverId = switch (index) {
                0 => betP1DriverId,
                1 => betP2DriverId,
                2 => betP3DriverId,
                3 => betP10DriverId,
                4 => betFastestLapDriverId,
                _ => null,
              };
              final String? resultsDriverId = switch (index) {
                0 => resultsP1DriverId,
                1 => resultsP2DriverId,
                2 => resultsP3DriverId,
                3 => resultsP10DriverId,
                4 => resultsFastestLapDriverId,
                _ => null,
              };

              return GrandPrixBetRow.build(
                context: context,
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
                points: 0,
              );
            },
          ),
        ),
        GrandPrixBetPointsSummary(
          details: [
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetPositions,
              value: '0',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetPositionsMultiplier,
              value: context.str.lack,
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetFastestLap,
              value: '0',
            ),
          ],
          totalPoints: 0,
        ),
      ],
    );
  }
}
