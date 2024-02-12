import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/driver.dart';
import '../../../riverpod_provider/all_drivers_provider.dart';
import 'grand_prix_bet_position_item.dart';
import 'grand_prix_bet_table.dart';

class GrandPrixBetRace extends ConsumerWidget {
  const GrandPrixBetRace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Driver>?> allDrivers = ref.watch(allDriversProvider);

    return GrandPrixBetTable(
      rows: List.generate(
        5,
        (index) => GrandPrixBetPositionItem.build(
          label: switch (index) {
            0 => '1.',
            1 => '2.',
            2 => '3.',
            3 => '10.',
            4 => 'Fastest Lap',
            _ => '',
          },
          selectedDriverId: null,
          allDrivers: allDrivers.value!,
          onDriverSelected: (String driverIndex) {
            //TODO
          },
        ),
      ),
    );
  }
}
