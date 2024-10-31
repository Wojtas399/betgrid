import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/grand_prix_bet.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/grand_prix_results.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../config/theme/custom_colors.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/widgets_list_extensions.dart';
import '../cubit/grand_prix_bet_cubit.dart';
import 'grand_prix_bet_driver_description.dart';
import 'grand_prix_bet_row.dart';
import 'grand_prix_bet_table.dart';
import 'grand_prix_points_summary.dart';

class GrandPrixBetRace extends StatelessWidget {
  const GrandPrixBetRace({super.key});

  @override
  Widget build(BuildContext context) {
    final GrandPrixBet? grandPrixBet = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixBet,
    );
    final RaceResults? raceResults = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixResults?.raceResults,
    );
    final RaceBetPoints? racePointsDetails = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.raceBetPoints,
    );
    final CustomColors? customColors = context.customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrandPrixBetTable(
          rows: [
            ...List.generate(
              5,
              (index) {
                final String? betDriverId = switch (index) {
                  0 => grandPrixBet?.p1DriverId,
                  1 => grandPrixBet?.p2DriverId,
                  2 => grandPrixBet?.p3DriverId,
                  3 => grandPrixBet?.p10DriverId,
                  4 => grandPrixBet?.fastestLapDriverId,
                  _ => null,
                };
                final String? resultsDriverId = switch (index) {
                  0 => raceResults?.p1DriverId,
                  1 => raceResults?.p2DriverId,
                  2 => raceResults?.p3DriverId,
                  3 => raceResults?.p10DriverId,
                  4 => raceResults?.fastestLapDriverId,
                  _ => null,
                };

                return GrandPrixBetRow(
                  label: switch (index) {
                    0 => 'P1',
                    1 => 'P2',
                    2 => 'P3',
                    3 => 'P10',
                    4 => 'FL',
                    _ => '',
                  },
                  labelColor: switch (index) {
                    0 => customColors?.p1,
                    1 => customColors?.p2,
                    2 => customColors?.p3,
                    4 => customColors?.fastestLap,
                    _ => null,
                  },
                  betChild: GrandPrixBetDriverDescription(
                    driverId: betDriverId,
                  ),
                  resultsChild: GrandPrixBetDriverDescription(
                    driverId: resultsDriverId,
                  ),
                  points: switch (index) {
                    0 => racePointsDetails?.p1Points,
                    1 => racePointsDetails?.p2Points,
                    2 => racePointsDetails?.p3Points,
                    3 => racePointsDetails?.p10Points,
                    4 => racePointsDetails?.fastestLapPoints,
                    _ => null,
                  },
                );
              },
            ),
            GrandPrixBetRow(
              label: 'DNF',
              betChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...?grandPrixBet?.dnfDriverIds
                      .map(
                        (e) => GrandPrixBetDriverDescription(driverId: e),
                      )
                      .separated(const GapVertical8()),
                ],
              ),
              resultsChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (raceResults?.dnfDriverIds.isNotEmpty == true)
                    ...?raceResults?.dnfDriverIds.map(
                      (e) => GrandPrixBetDriverDescription(driverId: e),
                    ),
                  if (raceResults?.dnfDriverIds.isEmpty != false)
                    BodyMedium(
                      context.str.lack,
                      fontWeight: FontWeight.bold,
                    ),
                ],
              ),
              points: racePointsDetails?.dnfPoints,
            ),
            GrandPrixBetRow(
              label: 'SC',
              betChild: Text(
                grandPrixBet?.willBeSafetyCar?.toI8nString(context) ?? '--',
              ),
              resultsChild: Text(
                raceResults?.wasThereSafetyCar.toI8nString(context) ?? '--',
              ),
              points: racePointsDetails?.safetyCarPoints,
            ),
            GrandPrixBetRow(
              label: 'RF',
              betChild: Text(
                grandPrixBet?.willBeRedFlag?.toI8nString(context) ?? '--',
              ),
              resultsChild: Text(
                raceResults?.wasThereRedFlag.toI8nString(context) ?? '--',
              ),
              points: racePointsDetails?.redFlagPoints,
            ),
          ],
        ),
        GrandPrixBetPointsSummary(
          details: [
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetPositions,
              value: '${racePointsDetails?.podiumAndP10Points ?? '--'}',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetPositionsMultiplier,
              value:
                  racePointsDetails?.podiumAndP10Multiplier?.toString() ?? '--',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetFastestLap,
              value: '${racePointsDetails?.fastestLapPoints ?? '--'}',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetDNF,
              value: '${racePointsDetails?.dnfPoints ?? '--'}',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetDNFMultiplier,
              value: racePointsDetails?.dnfMultiplier?.toString() ?? '--',
            ),
            GrandPrixPointsSummaryDetail(
              label: context.str.grandPrixBetOther,
              value: racePointsDetails != null
                  ? '${racePointsDetails.safetyCarPoints + racePointsDetails.redFlagPoints}'
                  : '--',
            ),
          ],
          totalPoints: racePointsDetails?.totalPoints,
        ),
      ],
    );
  }
}

extension _BoolExtensions on bool {
  String toI8nString(BuildContext context) => switch (this) {
        true => context.str.yes,
        false => context.str.no,
      };
}
