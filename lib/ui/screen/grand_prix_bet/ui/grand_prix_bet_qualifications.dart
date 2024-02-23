import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../dependency_injection.dart';
import '../../../../model/driver.dart';
import '../../../config/theme/custom_colors.dart';
import '../../../provider/all_drivers_provider.dart';
import '../notifier/grand_prix_bet_notifier.dart';
import 'grand_prix_bet_position_item.dart';
import 'grand_prix_bet_table.dart';

class GrandPrixBetQualifications extends ConsumerWidget {
  const GrandPrixBetQualifications({super.key});

  void _onDriverSelect(String driverId, int driverIndex, WidgetRef ref) {
    ref
        .read(grandPrixBetNotifierProvider.notifier)
        .onQualificationDriverChanged(driverIndex, driverId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String?>? standings = ref.watch(
      grandPrixBetNotifierProvider.select(
        (state) => state.value?.qualiStandingsByDriverIds,
      ),
    );
    final AsyncValue<List<Driver>?> allDrivers = ref.watch(allDriversProvider);

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
            allDrivers: allDrivers.value!,
            selectedDriverIds: standings.whereNotNull().toList(),
            onDriverSelected: (String driverId) {
              _onDriverSelect(driverId, itemIndex, ref);
            },
          );
        },
      ),
    );
  }
}
