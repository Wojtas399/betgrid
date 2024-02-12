import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/driver.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text/headline.dart';
import '../../../riverpod_provider/all_drivers_provider.dart';
import '../../../riverpod_provider/grand_prix_name_provider.dart';
import '../provider/qualifications_bet_drivers_standings_provider.dart';
import 'qualifications_bet_position_item.dart';

class QualificationsBetStandingsList extends ConsumerWidget {
  const QualificationsBetStandingsList({super.key});

  void _onDriverSelect(String driverId, int driverIndex, WidgetRef ref) {
    ref
        .read(qualificationsBetDriversStandingsProvider.notifier)
        .onPositionDriverChanged(driverIndex, driverId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<String?>?> standings = ref.watch(
      qualificationsBetDriversStandingsProvider,
    );
    final AsyncValue<List<Driver>?> allDrivers = ref.watch(allDriversProvider);

    return standings.value?.isNotEmpty == true &&
            allDrivers.value?.isNotEmpty == true
        ? SingleChildScrollView(
            child: Column(
              children: [
                const _GrandPrixName(),
                Column(
                  children: allDrivers.value!
                      .asMap()
                      .entries
                      .map<Widget>(
                        (entry) => QualificationsBetPositionItem(
                          selectedDriverId: standings.value![entry.key],
                          position: entry.key + 1,
                          allDrivers: allDrivers.value!,
                          onDriverSelected: (String driverId) {
                            _onDriverSelect(driverId, entry.key, ref);
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          )
        : const Column(
            children: [
              _GrandPrixName(),
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              GapVertical64(),
            ],
          );
  }
}

class _GrandPrixName extends ConsumerWidget {
  const _GrandPrixName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<String?> asyncValue = ref.watch(grandPrixNameProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeadlineMedium(
            '${asyncValue.value}',
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
