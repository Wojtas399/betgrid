import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../dependency_injection.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import '../../config/theme/custom_colors.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/bet_points/race_bet_points_provider.dart';
import '../../provider/bet_points/race_single_bet_points_provider.dart';
import '../../provider/grand_prix_results_provider.dart';
import '../../provider/notifier/grand_prix_bet/grand_prix_bet_notifier_provider.dart';
import 'grand_prix_bet_position_item.dart';
import 'grand_prix_bet_table.dart';

class GrandPrixBetRace extends ConsumerWidget {
  const GrandPrixBetRace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? betP1DriverId = ref.watch(
      grandPrixBetNotifierProvider.select((state) => state.value?.p1DriverId),
    );
    final String? betP2DriverId = ref.watch(
      grandPrixBetNotifierProvider.select((state) => state.value?.p2DriverId),
    );
    final String? betP3DriverId = ref.watch(
      grandPrixBetNotifierProvider.select((state) => state.value?.p3DriverId),
    );
    final String? betP10DriverId = ref.watch(
      grandPrixBetNotifierProvider.select((state) => state.value?.p10DriverId),
    );
    final String? betFastestLapDriverId = ref.watch(
      grandPrixBetNotifierProvider.select(
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
    final AsyncValue<RaceBetPointsDetails?> pointsSummary = ref.watch(
      raceBetPointsProvider,
    );

    return Column(
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

              return GrandPrixBetPositionItem.build(
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
                betDriverId: betDriverId,
                resultsDriverId: resultsDriverId,
                points: ref.watch(
                  raceSingleBetPointsProvider(
                    positionType: switch (index) {
                      0 => RacePositionType.p1,
                      1 => RacePositionType.p2,
                      2 => RacePositionType.p3,
                      3 => RacePositionType.p10,
                      4 => RacePositionType.fastestLap,
                      int() => throw UnimplementedError(),
                    },
                    betDriverId: betDriverId,
                    resultsDriverId: resultsDriverId,
                  ),
                ),
              );
            },
          ),
        ),
        const GapVertical8(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyLarge('Punkty za pozycje: '),
              BodyLarge(
                '${pointsSummary.value?.pointsForPositions ?? '--'}',
              ),
            ],
          ),
        ),
        const GapVertical8(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyLarge('Mnożnik punktów za pozycje: '),
              BodyLarge(
                '${pointsSummary.value?.positionsPointsMultiplier ?? 'Brak'}',
              ),
            ],
          ),
        ),
        const GapVertical8(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyLarge('Punkty za najszybsze okrążenie: '),
              BodyLarge(
                '${pointsSummary.value?.pointsForFastestLap ?? 'Brak'}',
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleLarge('${context.str.grandPrixBetResult}: '),
              TitleLarge(
                '${pointsSummary.value?.totalPoints ?? '--'}',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
