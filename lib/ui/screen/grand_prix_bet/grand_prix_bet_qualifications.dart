import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_method_providers.dart';
import '../../../dependency_injection.dart';
import '../../../model/grand_prix_bet_points.dart';
import '../../config/theme/custom_colors.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/grand_prix_id_provider.dart';
import 'grand_prix_bet_driver_description.dart';
import 'grand_prix_bet_row.dart';
import 'grand_prix_bet_table.dart';
import 'grand_prix_points_summary.dart';
import 'provider/grand_prix_bet_provider.dart';
import 'provider/grand_prix_results_provider.dart';
import 'provider/player_id_provider.dart';

class GrandPrixBetQualifications extends ConsumerWidget {
  const GrandPrixBetQualifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String?>? standings = ref.watch(
      grandPrixBetProvider.select(
        (state) => state.value?.qualiStandingsByDriverIds,
      ),
    );
    final List<String?>? resultsStandings = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.qualiStandingsByDriverIds,
      ),
    );
    final String? grandPrixId = ref.watch(grandPrixIdProvider);
    final String? playerId = ref.watch(playerIdProvider);
    QualiBetPoints? qualiPointsDetails;
    if (grandPrixId != null && playerId != null) {
      qualiPointsDetails = ref.watch(
        grandPrixBetPointsProvider(
          grandPrixId: grandPrixId,
          playerId: playerId,
        ).select((state) => state.value?.qualiBetPoints),
      );
    }
    final List<double>? positionsPoints = qualiPointsDetails != null
        ? [
            qualiPointsDetails.q1P1Points,
            qualiPointsDetails.q1P2Points,
            qualiPointsDetails.q1P3Points,
            qualiPointsDetails.q1P4Points,
            qualiPointsDetails.q1P5Points,
            qualiPointsDetails.q1P6Points,
            qualiPointsDetails.q1P7Points,
            qualiPointsDetails.q1P8Points,
            qualiPointsDetails.q1P9Points,
            qualiPointsDetails.q1P10Points,
            qualiPointsDetails.q2P11Points,
            qualiPointsDetails.q2P12Points,
            qualiPointsDetails.q2P13Points,
            qualiPointsDetails.q2P14Points,
            qualiPointsDetails.q2P15Points,
            qualiPointsDetails.q3P16Points,
            qualiPointsDetails.q3P17Points,
            qualiPointsDetails.q3P18Points,
            qualiPointsDetails.q3P19Points,
            qualiPointsDetails.q3P20Points,
          ]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrandPrixBetTable(
          rows: List.generate(
            20,
            (int itemIndex) {
              final int qualiNumber = itemIndex > 14
                  ? 3
                  : itemIndex > 9
                      ? 2
                      : 1;

              return GrandPrixBetRow(
                label: 'Q$qualiNumber P${itemIndex + 1}',
                labelBackgroundColor: switch (itemIndex) {
                  0 => getIt<CustomColors>().gold,
                  1 => getIt<CustomColors>().silver,
                  2 => getIt<CustomColors>().brown,
                  _ => null,
                },
                betChild: DriverDescription(
                  driverId: standings![itemIndex],
                ),
                resultsChild: DriverDescription(
                  driverId: resultsStandings?[itemIndex],
                ),
                points: positionsPoints?[itemIndex],
              );
            },
          ),
        ),
        GrandPrixBetPointsSummary(
          details: [
            GrandPrixPointsSummaryDetail(
              label: 'Q1',
              value: '${qualiPointsDetails?.q1Points ?? '--'}',
            ),
            GrandPrixPointsSummaryDetail(
              label: 'Q2',
              value: '${qualiPointsDetails?.q2Points ?? '--'}',
            ),
            GrandPrixPointsSummaryDetail(
              label: 'Q3',
              value: '${qualiPointsDetails?.q3Points ?? '--'}',
            ),
            GrandPrixPointsSummaryDetail(
              label: '${context.str.grandPrixBetMultiplier} Q1',
              value: qualiPointsDetails?.q1Multiplier?.toString() ?? '--',
            ),
            GrandPrixPointsSummaryDetail(
              label: '${context.str.grandPrixBetMultiplier} Q2',
              value: qualiPointsDetails?.q2Multiplier?.toString() ?? '--',
            ),
            GrandPrixPointsSummaryDetail(
              label: '${context.str.grandPrixBetMultiplier} Q3',
              value: qualiPointsDetails?.q3Multiplier?.toString() ?? '--',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetMultiplier,
              value: qualiPointsDetails?.multiplier?.toString() ?? '--',
            ),
          ],
          totalPoints: qualiPointsDetails?.totalPoints,
        ),
      ],
    );
  }
}
