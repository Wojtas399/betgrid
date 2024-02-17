import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../dependency_injection.dart';
import '../../../../model/driver.dart';
import '../../../config/theme/custom_colors.dart';
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
          context: context,
          label: switch (index) {
            0 => 'P1',
            1 => 'P2',
            2 => 'P3',
            3 => 'P10',
            4 => 'Fastest Lap',
            _ => '',
          },
          labelBackgroundColor: switch (index) {
            0 => getIt<CustomColors>().gold,
            1 => getIt<CustomColors>().silver,
            2 => getIt<CustomColors>().brown,
            4 => getIt<CustomColors>().violet,
            _ => null,
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
          selectedDriverIds: index == 4
              ? []
              : [p1DriverId, p2DriverId, p3DriverId, p10DriverId]
                  .whereNotNull()
                  .toList(),
          onDriverSelected: (String driverId) {
            _onDriverSelected(index, driverId, ref);
          },
        ),
      ),
    );
  }
}
