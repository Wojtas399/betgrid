import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/driver.dart';
import '../../../riverpod_provider/all_drivers_provider.dart';
import '../notifier/grand_prix_bet_notifier.dart';
import 'grand_prix_bet_position_item.dart';
import 'grand_prix_bet_position_yes_no_item.dart';
import 'grand_prix_bet_table.dart';

class GrandPrixBetAdditional extends ConsumerWidget {
  const GrandPrixBetAdditional({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Driver>?> allDrivers = ref.watch(allDriversProvider);
    final gpBetNotifier = ref.read(grandPrixBetNotifierProvider.notifier);
    final List<String?>? dnfDriverIds = ref.watch(
      grandPrixBetNotifierProvider.select(
        (state) => state.value?.dnfDriverIds,
      ),
    );
    final bool? willBeSafetyCar = ref.watch(
      grandPrixBetNotifierProvider.select(
        (state) => state.value?.willBeSafetyCar,
      ),
    );
    final bool? willBeRedFlag = ref.watch(
      grandPrixBetNotifierProvider.select(
        (state) => state.value?.willBeRedFlag,
      ),
    );

    return GrandPrixBetTable(
      rows: [
        ...List.generate(
          3,
          (index) => GrandPrixBetPositionItem.build(
            context: context,
            label: switch (index) {
              0 => 'DNF',
              1 => 'DNF',
              2 => 'DNF',
              _ => '',
            },
            selectedDriverId: dnfDriverIds![index],
            allDrivers: allDrivers.value!,
            selectedDriverIds: dnfDriverIds.whereNotNull().toList(),
            onDriverSelected: (String driverId) {
              gpBetNotifier.onDnfDriverChanged(index, driverId);
            },
          ),
        ),
        GrandPrixBetPositionYesNoItem.build(
          context: context,
          label: 'Safety Car',
          initialValue: willBeSafetyCar,
          onChanged: gpBetNotifier.onSafetyCarPossibilityChanged,
        ),
        GrandPrixBetPositionYesNoItem.build(
          context: context,
          label: 'Red Flag',
          initialValue: willBeRedFlag,
          onChanged: gpBetNotifier.onRedFlagPossibilityChanged,
        ),
      ],
    );
  }
}
