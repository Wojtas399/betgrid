import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/driver.dart';
import '../../../riverpod_provider/all_drivers_provider.dart';
import '../notifier/grand_prix_bet_notifier.dart';
import 'grand_prix_bet_position_item.dart';
import 'grand_prix_bet_table.dart';

class GrandPrixBetRace extends ConsumerWidget {
  const GrandPrixBetRace({super.key});

  void _onDriverSelected(int rowIndex, String driverId, WidgetRef ref) {
    final notifier = ref.read(grandPrixBetNotifierProvider.notifier);
    switch (rowIndex) {
      case 0:
        notifier.onP1DriverChanged(driverId);
      case 1:
        notifier.onP2DriverChanged(driverId);
      case 2:
        notifier.onP3DriverChanged(driverId);
      case 3:
        notifier.onP10DriverChanged(driverId);
      case 4:
        notifier.onFastestLapDriverChanged(driverId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Driver>?> allDrivers = ref.watch(allDriversProvider);
    final String? p1DriverId = ref.watch(
      grandPrixBetNotifierProvider.select((state) => state.value?.p1DriverId),
    );
    final String? p2DriverId = ref.watch(
      grandPrixBetNotifierProvider.select((state) => state.value?.p2DriverId),
    );
    final String? p3DriverId = ref.watch(
      grandPrixBetNotifierProvider.select((state) => state.value?.p3DriverId),
    );
    final String? p10DriverId = ref.watch(
      grandPrixBetNotifierProvider.select((state) => state.value?.p10DriverId),
    );
    final String? fastestLapDriverId = ref.watch(
      grandPrixBetNotifierProvider.select(
        (state) => state.value?.fastestLapDriverId,
      ),
    );

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
          selectedDriverId: switch (index) {
            0 => p1DriverId,
            1 => p2DriverId,
            2 => p3DriverId,
            3 => p10DriverId,
            4 => fastestLapDriverId,
            _ => null,
          },
          allDrivers: allDrivers.value!,
          onDriverSelected: (String driverId) {
            _onDriverSelected(index, driverId, ref);
          },
        ),
      ),
    );
  }
}
