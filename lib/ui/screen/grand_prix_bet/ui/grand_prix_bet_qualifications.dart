import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/driver.dart';
import '../../../riverpod_provider/all_drivers_provider.dart';
import '../provider/grand_prix_bet_qualifications_notifier.dart';
import 'grand_prix_bet_position_item.dart';
import 'grand_prix_bet_table.dart';

class GrandPrixBetQualifications extends ConsumerWidget {
  const GrandPrixBetQualifications({super.key});

  void _onDriverSelect(String driverId, int driverIndex, WidgetRef ref) {
    ref
        .read(grandPrixBetQualificationsNotifierProvider.notifier)
        .onPositionDriverChanged(driverIndex, driverId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<String?>?> standings = ref.watch(
      grandPrixBetQualificationsNotifierProvider,
    );
    final AsyncValue<List<Driver>?> allDrivers = ref.watch(allDriversProvider);

    return GrandPrixBetTable(
      rows: List.generate(
        20,
        (int itemIndex) => GrandPrixBetPositionItem.build(
          selectedDriverId: standings.value![itemIndex],
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
