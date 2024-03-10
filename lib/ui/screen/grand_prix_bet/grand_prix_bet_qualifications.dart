import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dependency_injection.dart';
import '../../config/theme/custom_colors.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/grand_prix_bet/grand_prix_bet_provider.dart';
import '../../provider/grand_prix_results_provider.dart';
import 'grand_prix_bet_driver_description.dart';
import 'grand_prix_bet_row.dart';
import 'grand_prix_bet_table.dart';
import 'grand_prix_points_summary.dart';

class GrandPrixBetQualifications extends ConsumerWidget {
  const GrandPrixBetQualifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String?>? standings = ref.watch(
      grandPrixBetProvider.select(
        (state) => state.value?.qualiStandingsByDriverIds,
      ),
    );
    final List<String>? resultsStandings = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.qualiStandingsByDriverIds,
      ),
    );

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

              return GrandPrixBetRow.build(
                context: context,
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
              label: context.str.grandPrixBetMultiplier,
              value: 'Brak',
            ),
          ],
          totalPoints: 0,
        ),
      ],
    );
  }
}
