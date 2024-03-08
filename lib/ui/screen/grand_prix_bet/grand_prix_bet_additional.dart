import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../component/gap/gap_horizontal.dart';
import '../../component/text/body.dart';
import '../../component/text/label.dart';
import '../../provider/bet_points/bonus_bet_points_provider.dart';
import '../../provider/bet_points/safety_car_and_red_flag_points_provider.dart';
import '../../provider/grand_prix_results_provider.dart';
import '../../provider/notifier/grand_prix_bet/grand_prix_bet_notifier_provider.dart';
import 'grand_prix_bet_label_cell.dart';
import 'grand_prix_bet_position_item.dart';
import 'grand_prix_bet_position_yes_no_item.dart';
import 'grand_prix_bet_table.dart';

class GrandPrixBetAdditional extends ConsumerWidget {
  const GrandPrixBetAdditional({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final List<String>? resultsDnfDriverIds = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.raceResults?.dnfDriverIds,
      ),
    );
    final bool? resultsWasThereSafetyCar = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.raceResults?.wasThereSafetyCar,
      ),
    );
    final bool? resultsWasThereRedFlag = ref.watch(
      grandPrixResultsProvider.select(
        (state) => state.value?.raceResults?.wasThereRedFlag,
      ),
    );
    final pointsDetails = ref.watch(bonusBetPointsProvider);

    return GrandPrixBetTable(
      rows: [
        TableRow(
          children: [
            GrandPrixBetLabelCell.build(
              context: context,
              label: 'DNF',
            ),
            TableCell(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 48,
                          child: LabelLarge('Typy: '),
                        ),
                        const GapHorizontal8(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...?dnfDriverIds?.map(
                              (e) => DriverDescription(driverId: e),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 0.25),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 48,
                          child: LabelLarge('Wynik: '),
                        ),
                        const GapHorizontal8(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (resultsDnfDriverIds?.isNotEmpty == true)
                              ...?resultsDnfDriverIds?.map(
                                (e) => DriverDescription(driverId: e),
                              ),
                            if (resultsDnfDriverIds?.isEmpty == true)
                              const BodyMedium(
                                'Brak',
                                fontWeight: FontWeight.bold,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BetPoints.build(
              context: context,
              points: pointsDetails.value?.dnfDriversPoints,
            ),
          ],
        ),
        GrandPrixBetPositionYesNoItem.build(
          context: context,
          label: 'SC',
          initialValue: willBeSafetyCar,
          points: ref.watch(
            safetyCarAndRedFlagPointsProvider(
              resultsVal: resultsWasThereSafetyCar,
              betVal: willBeSafetyCar,
            ),
          ),
        ),
        GrandPrixBetPositionYesNoItem.build(
          context: context,
          label: 'RF',
          initialValue: willBeRedFlag,
          points: ref.watch(
            safetyCarAndRedFlagPointsProvider(
              resultsVal: resultsWasThereRedFlag,
              betVal: willBeRedFlag,
            ),
          ),
        ),
      ],
    );
  }
}
