import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/driver.dart';
import '../../../riverpod_provider/all_drivers_provider.dart';
import '../notifier/grand_prix_bet_notifier.dart';
import 'grand_prix_bet_position_item.dart';
import 'grand_prix_bet_table.dart';

class GrandPrixBetQualifications extends ConsumerWidget {
  const GrandPrixBetQualifications({super.key});

  void _onDriverSelect(String driverId, int driverIndex, WidgetRef ref) {
    ref
        .read(grandPrixBetNotifierProvider.notifier)
        .onPositionDriverChanged(driverIndex, driverId);
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
        (int itemIndex) => GrandPrixBetPositionItem.build(
          selectedDriverId: standings![itemIndex],
          label: '${itemIndex + 1}.',
          allDrivers: allDrivers.value!,
          onDriverSelected: (String driverId) {
            _onDriverSelect(driverId, itemIndex, ref);
          },
        ),
      ),
    );
  }
}
