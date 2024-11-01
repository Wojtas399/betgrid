import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/grand_prix_bet_points.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/widgets_list_extensions.dart';
import '../cubit/grand_prix_bet_cubit.dart';
import 'grand_prix_bet_driver_description.dart';
import 'grand_prix_bet_item.dart';
import 'grand_prix_bet_no_data_field.dart';
import 'grand_prix_points_summary.dart';

class GrandPrixBetRace extends StatelessWidget {
  const GrandPrixBetRace({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _P1(),
          _P2(),
          _P3(),
          _P10(),
          _FastestLap(),
          _DnfDrivers(),
          _SafetyCar(),
          _RedFlag(),
          _PointsSummary(),
        ],
      );
}

class _P1 extends StatelessWidget {
  const _P1();

  @override
  Widget build(BuildContext context) {
    final String? betDriverId = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixBet?.p1DriverId,
    );
    final String? resultsDriverId = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixResults?.raceResults?.p1DriverId,
    );
    final double? points = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.raceBetPoints?.p1Points,
    );

    return GrandPrixBetItem(
      label: 'P1',
      labelColor: context.customColors?.p1,
      betChild: GrandPrixBetDriverDescription(
        driverId: betDriverId,
      ),
      resultsChild: GrandPrixBetDriverDescription(
        driverId: resultsDriverId,
      ),
      points: points,
    );
  }
}

class _P2 extends StatelessWidget {
  const _P2();

  @override
  Widget build(BuildContext context) {
    final String? betDriverId = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixBet?.p2DriverId,
    );
    final String? resultsDriverId = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixResults?.raceResults?.p2DriverId,
    );
    final double? points = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.raceBetPoints?.p2Points,
    );

    return GrandPrixBetItem(
      label: 'P2',
      labelColor: context.customColors?.p2,
      betChild: GrandPrixBetDriverDescription(
        driverId: betDriverId,
      ),
      resultsChild: GrandPrixBetDriverDescription(
        driverId: resultsDriverId,
      ),
      points: points,
    );
  }
}

class _P3 extends StatelessWidget {
  const _P3();

  @override
  Widget build(BuildContext context) {
    final String? betDriverId = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixBet?.p3DriverId,
    );
    final String? resultsDriverId = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixResults?.raceResults?.p3DriverId,
    );
    final double? points = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.raceBetPoints?.p3Points,
    );

    return GrandPrixBetItem(
      label: 'P3',
      labelColor: context.customColors?.p3,
      betChild: GrandPrixBetDriverDescription(
        driverId: betDriverId,
      ),
      resultsChild: GrandPrixBetDriverDescription(
        driverId: resultsDriverId,
      ),
      points: points,
    );
  }
}

class _P10 extends StatelessWidget {
  const _P10();

  @override
  Widget build(BuildContext context) {
    final String? betDriverId = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixBet?.p10DriverId,
    );
    final String? resultsDriverId = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixResults?.raceResults?.p10DriverId,
    );
    final double? points = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.raceBetPoints?.p10Points,
    );

    return GrandPrixBetItem(
      label: 'P10',
      betChild: GrandPrixBetDriverDescription(
        driverId: betDriverId,
      ),
      resultsChild: GrandPrixBetDriverDescription(
        driverId: resultsDriverId,
      ),
      points: points,
    );
  }
}

class _FastestLap extends StatelessWidget {
  const _FastestLap();

  @override
  Widget build(BuildContext context) {
    final String? betDriverId = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixBet?.fastestLapDriverId,
    );
    final String? resultsDriverId = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixResults?.raceResults?.fastestLapDriverId,
    );
    final double? points = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.raceBetPoints?.fastestLapPoints,
    );

    return GrandPrixBetItem(
      label: context.str.fastestLap,
      betChild: GrandPrixBetDriverDescription(
        driverId: betDriverId,
      ),
      resultsChild: GrandPrixBetDriverDescription(
        driverId: resultsDriverId,
      ),
      points: points,
    );
  }
}

class _DnfDrivers extends StatelessWidget {
  const _DnfDrivers();

  @override
  Widget build(BuildContext context) {
    final List<String>? betDnfDriverIds = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixBet?.dnfDriverIds,
    );
    final List<String>? resultsDnfDriverIds = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixResults?.raceResults?.dnfDriverIds,
    );
    final double? points = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.raceBetPoints?.dnfPoints,
    );

    return GrandPrixBetItem(
      label: 'DNF',
      betChild: Column(
        children: [
          if (betDnfDriverIds != null)
            ...betDnfDriverIds
                .map(
                  (driverId) => GrandPrixBetDriverDescription(
                    driverId: driverId,
                  ),
                )
                .separated(const GapVertical8())
          else
            const GrandPrixBetNoDataField(),
        ],
      ),
      resultsChild: Column(
        children: [
          if (resultsDnfDriverIds?.isNotEmpty == true)
            ...?resultsDnfDriverIds
                ?.map(
                  (driverId) => GrandPrixBetDriverDescription(
                    driverId: driverId,
                  ),
                )
                .separated(const GapVertical8())
          else
            const GrandPrixBetNoDataField(),
        ],
      ),
      points: points,
    );
  }
}

class _SafetyCar extends StatelessWidget {
  const _SafetyCar();

  @override
  Widget build(BuildContext context) {
    final bool? betWhetherWillBeSafetyCar = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixBet?.willBeSafetyCar,
    );
    final bool? resultsWhetherWasSafetyCar = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixResults?.raceResults?.wasThereSafetyCar,
    );
    final double? points = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.raceBetPoints?.safetyCarPoints,
    );
    final String? betSafetyCarStr =
        betWhetherWillBeSafetyCar?.toI8nString(context);
    final String? resultsSafetyCarStr =
        resultsWhetherWasSafetyCar?.toI8nString(context);

    return GrandPrixBetItem(
      label: context.str.safetyCar,
      betChild: betSafetyCarStr != null
          ? BodyMedium(betSafetyCarStr)
          : const GrandPrixBetNoDataField(),
      resultsChild: resultsSafetyCarStr != null
          ? Text(resultsSafetyCarStr)
          : const GrandPrixBetNoDataField(),
      points: points,
    );
  }
}

class _RedFlag extends StatelessWidget {
  const _RedFlag();

  @override
  Widget build(BuildContext context) {
    final bool? betWhetherWillBeRedFlag = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixBet?.willBeRedFlag,
    );
    final bool? resultsWhetherWasRedFlag = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixResults?.raceResults?.wasThereRedFlag,
    );
    final double? points = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.raceBetPoints?.redFlagPoints,
    );
    final String? betRedFlagStr = betWhetherWillBeRedFlag?.toI8nString(context);
    final String? resultsRedFlagStr =
        resultsWhetherWasRedFlag?.toI8nString(context);

    return GrandPrixBetItem(
      label: context.str.redFlag,
      betChild: betRedFlagStr != null
          ? Text(betRedFlagStr)
          : const GrandPrixBetNoDataField(),
      resultsChild: resultsRedFlagStr != null
          ? Text(resultsRedFlagStr)
          : const GrandPrixBetNoDataField(),
      points: points,
    );
  }
}

class _PointsSummary extends StatelessWidget {
  const _PointsSummary();

  @override
  Widget build(BuildContext context) {
    final RaceBetPoints? racePoints = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.raceBetPoints,
    );

    return GrandPrixBetPointsSummary(
      details: [
        GrandPrixPointsSummaryDetail(
          label: context.str.grandPrixBetPositions,
          value: racePoints?.podiumAndP10Points,
        ),
        GrandPrixPointsSummaryDetail(
          label: context.str.grandPrixBetPositionsMultiplier,
          value: racePoints?.podiumAndP10Multiplier,
        ),
        GrandPrixPointsSummaryDetail(
          label: context.str.grandPrixBetFastestLap,
          value: racePoints?.fastestLapPoints,
        ),
        GrandPrixPointsSummaryDetail(
          label: context.str.grandPrixBetDNF,
          value: racePoints?.dnfPoints,
        ),
        GrandPrixPointsSummaryDetail(
          label: context.str.grandPrixBetDNFMultiplier,
          value: racePoints?.dnfMultiplier,
        ),
        GrandPrixPointsSummaryDetail(
          label: context.str.grandPrixBetOther,
          value: racePoints != null
              ? racePoints.safetyCarPoints + racePoints.redFlagPoints
              : null,
        ),
      ],
      totalPoints: racePoints?.totalPoints,
    );
  }
}

extension _BoolExtensions on bool {
  String toI8nString(BuildContext context) => switch (this) {
        true => context.str.yes,
        false => context.str.no,
      };
}
