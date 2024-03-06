import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dependency_injection.dart';
import '../../config/theme/custom_colors.dart';
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

    return GrandPrixBetTable(
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
            selectedDriverId: standings![itemIndex],
            label: 'Q$qualiNumber - P${itemIndex + 1}',
            labelBackgroundColor: switch (itemIndex) {
              0 => getIt<CustomColors>().gold,
              1 => getIt<CustomColors>().silver,
              2 => getIt<CustomColors>().brown,
              _ => null,
            },
            selectedDriverIds: standings.whereNotNull().toList(),
          );
        },
      ),
    );
  }
}
