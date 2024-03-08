import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dependency_injection.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import '../../config/theme/custom_colors.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/bet_points/quali_bet_points_provider.dart';
import '../../provider/bet_points/quali_position_bet_points_provider.dart';
import '../../provider/grand_prix_results_provider.dart';
import '../../provider/notifier/grand_prix_bet/grand_prix_bet_notifier_provider.dart';
import 'grand_prix_bet_position_item.dart';
import 'grand_prix_bet_table.dart';

class GrandPrixBetQualifications extends ConsumerWidget {
  const GrandPrixBetQualifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String?>? standings = ref.watch(
      grandPrixBetNotifierProvider.select(
        (state) => state.value?.qualiStandingsByDriverIds,
      ),
    );
    final List<String>? resultsStandings = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.qualiStandingsByDriverIds,
      ),
    );
    final pointsSummary = ref.watch(qualiBetPointsProvider);

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

              return GrandPrixBetPositionItem.build(
                context: context,
                betDriverId: standings![itemIndex],
                resultsDriverId: resultsStandings?[itemIndex],
                label: 'Q$qualiNumber P${itemIndex + 1}',
                labelBackgroundColor: switch (itemIndex) {
                  0 => getIt<CustomColors>().gold,
                  1 => getIt<CustomColors>().silver,
                  2 => getIt<CustomColors>().brown,
                  _ => null,
                },
                points: ref.watch(
                  qualiPositionBetPointsProvider(
                    resultsStandings: resultsStandings ?? [],
                    betStandings: standings,
                    positionIndex: itemIndex,
                  ),
                ),
              );
            },
          ),
        ),
        // Divider(),
        const GapVertical8(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyLarge('${context.str.grandPrixBetPoints}: '),
              BodyLarge(
                '${pointsSummary.value?.pointsBeforeMultiplication ?? '--'}',
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
              BodyLarge('${context.str.grandPrixBetMultiplier}: '),
              BodyLarge('${pointsSummary.value?.multiplier ?? 'Brak'}'),
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
