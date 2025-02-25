import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../model/driver_details.dart';
import '../../../../../model/season_grand_prix_bet_points.dart';
import '../../../../component/driver_description_component.dart';
import '../../../../component/gap/gap_vertical.dart';
import '../../../../component/no_text_component.dart';
import '../../../../component/padding/padding_components.dart';
import '../../../../component/text_component.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../../../../extensions/string_extensions.dart';
import '../../../../extensions/widgets_list_extensions.dart';
import '../cubit/season_grand_prix_bet_preview_cubit.dart';
import '../cubit/season_grand_prix_bet_preview_state.dart';
import 'season_grand_prix_bet_preview_item.dart';
import 'season_grand_prix_bet_preview_no_data_field.dart';
import 'season_grand_prix_bet_preview_section_title.dart';
import 'season_grand_prix_preview_points_summary.dart';

class SeasonGrandPrixBetPreviewRace extends StatelessWidget {
  const SeasonGrandPrixBetPreviewRace({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _Title(),
      children: [
        const Padding16(child: Column(children: [_Bets(), _PointsSummary()])),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double? racePoints = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) =>
          cubit.state.seasonGrandPrixBetPoints?.raceBetPoints?.total,
    );

    return SeasonGrandPrixBetPreviewSectionTitle(
      title: context.str.race,
      points: racePoints,
    );
  }
}

class _Bets extends StatelessWidget {
  const _Bets();

  @override
  Widget build(BuildContext context) {
    return const Column(
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
      ],
    );
  }
}

class _P1 extends StatelessWidget {
  const _P1();

  @override
  Widget build(BuildContext context) {
    final SingleDriverBet? bet = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) =>
          cubit.state.racePodiumBets?.first,
    );

    return SeasonGrandPrixBetPreviewItem(
      label: 'P1',
      labelColor: context.customColors?.p1,
      betStatus: bet?.status,
      betChild:
          bet?.betDriver != null
              ? DriverDescription(
                name: bet!.betDriver!.name,
                surname: bet.betDriver!.surname,
                number: bet.betDriver!.number,
                teamColor: bet.betDriver!.teamHexColor.toColor(),
              )
              : const NoText(),
      resultsChild:
          bet?.resultDriver != null
              ? DriverDescription(
                name: bet!.resultDriver!.name,
                surname: bet.resultDriver!.surname,
                number: bet.resultDriver!.number,
                teamColor: bet.resultDriver!.teamHexColor.toColor(),
              )
              : const NoText(),
      points: bet?.points,
    );
  }
}

class _P2 extends StatelessWidget {
  const _P2();

  @override
  Widget build(BuildContext context) {
    final SingleDriverBet? bet = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) => cubit.state.racePodiumBets?[1],
    );

    return SeasonGrandPrixBetPreviewItem(
      label: 'P2',
      labelColor: context.customColors?.p2,
      betStatus: bet?.status,
      betChild:
          bet?.betDriver != null
              ? DriverDescription(
                name: bet!.betDriver!.name,
                surname: bet.betDriver!.surname,
                number: bet.betDriver!.number,
                teamColor: bet.betDriver!.teamHexColor.toColor(),
              )
              : const NoText(),
      resultsChild:
          bet?.resultDriver != null
              ? DriverDescription(
                name: bet!.resultDriver!.name,
                surname: bet.resultDriver!.surname,
                number: bet.resultDriver!.number,
                teamColor: bet.resultDriver!.teamHexColor.toColor(),
              )
              : const NoText(),
      points: bet?.points,
    );
  }
}

class _P3 extends StatelessWidget {
  const _P3();

  @override
  Widget build(BuildContext context) {
    final SingleDriverBet? bet = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) =>
          cubit.state.racePodiumBets?.last,
    );

    return SeasonGrandPrixBetPreviewItem(
      label: 'P3',
      labelColor: context.customColors?.p3,
      betStatus: bet?.status,
      betChild:
          bet?.betDriver != null
              ? DriverDescription(
                name: bet!.betDriver!.name,
                surname: bet.betDriver!.surname,
                number: bet.betDriver!.number,
                teamColor: bet.betDriver!.teamHexColor.toColor(),
              )
              : const NoText(),
      resultsChild:
          bet?.resultDriver != null
              ? DriverDescription(
                name: bet!.resultDriver!.name,
                surname: bet.resultDriver!.surname,
                number: bet.resultDriver!.number,
                teamColor: bet.resultDriver!.teamHexColor.toColor(),
              )
              : const NoText(),
      points: bet?.points,
    );
  }
}

class _P10 extends StatelessWidget {
  const _P10();

  @override
  Widget build(BuildContext context) {
    final SingleDriverBet? bet = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) => cubit.state.raceP10Bet,
    );

    return SeasonGrandPrixBetPreviewItem(
      label: 'P10',
      betStatus: bet?.status,
      betChild:
          bet?.betDriver != null
              ? DriverDescription(
                name: bet!.betDriver!.name,
                surname: bet.betDriver!.surname,
                number: bet.betDriver!.number,
                teamColor: bet.betDriver!.teamHexColor.toColor(),
              )
              : const NoText(),
      resultsChild:
          bet?.resultDriver != null
              ? DriverDescription(
                name: bet!.resultDriver!.name,
                surname: bet.resultDriver!.surname,
                number: bet.resultDriver!.number,
                teamColor: bet.resultDriver!.teamHexColor.toColor(),
              )
              : const NoText(),
      points: bet?.points,
    );
  }
}

class _FastestLap extends StatelessWidget {
  const _FastestLap();

  @override
  Widget build(BuildContext context) {
    final SingleDriverBet? bet = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) => cubit.state.raceFastestLapBet,
    );

    return SeasonGrandPrixBetPreviewItem(
      label: context.str.fastestLap,
      betStatus: bet?.status,
      betChild:
          bet?.betDriver != null
              ? DriverDescription(
                name: bet!.betDriver!.name,
                surname: bet.betDriver!.surname,
                number: bet.betDriver!.number,
                teamColor: bet.betDriver!.teamHexColor.toColor(),
              )
              : const NoText(),
      resultsChild:
          bet?.resultDriver != null
              ? DriverDescription(
                name: bet!.resultDriver!.name,
                surname: bet.resultDriver!.surname,
                number: bet.resultDriver!.number,
                teamColor: bet.resultDriver!.teamHexColor.toColor(),
              )
              : const NoText(),
      points: bet?.points,
    );
  }
}

class _DnfDrivers extends StatelessWidget {
  const _DnfDrivers();

  @override
  Widget build(BuildContext context) {
    final MultipleDriversBet? bet = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) => cubit.state.raceDnfDriversBet,
    );
    final List<DriverDetails?>? betDnfDrivers = bet?.betDrivers;
    final List<DriverDetails?>? resultDnfDrivers = bet?.resultDrivers;

    return SeasonGrandPrixBetPreviewItem(
      label: 'DNF',
      betStatus: bet?.status,
      betChild: Column(
        children: [
          if (betDnfDrivers != null)
            ...betDnfDrivers
                .map(
                  (driver) =>
                      driver != null
                          ? DriverDescription(
                            name: driver.name,
                            surname: driver.surname,
                            number: driver.number,
                            teamColor: driver.teamHexColor.toColor(),
                          )
                          : const NoText(),
                )
                .separated(const GapVertical8())
          else
            const GrandPrixBetNoDataField(),
        ],
      ),
      resultsChild: Column(
        children: [
          if (resultDnfDrivers?.isNotEmpty == true)
            ...?resultDnfDrivers
                ?.map(
                  (driver) =>
                      driver != null
                          ? DriverDescription(
                            name: driver.name,
                            surname: driver.surname,
                            number: driver.number,
                            teamColor: driver.teamHexColor.toColor(),
                          )
                          : const NoText(),
                )
                .separated(const GapVertical8())
          else
            const GrandPrixBetNoDataField(),
        ],
      ),
      points: bet?.points,
    );
  }
}

class _SafetyCar extends StatelessWidget {
  const _SafetyCar();

  @override
  Widget build(BuildContext context) {
    final BooleanBet? bet = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) => cubit.state.raceSafetyCarBet,
    );
    final String? betSafetyCarStr = bet?.betValue?.toI8nString(context);
    final String? resultsSafetyCarStr = bet?.resultValue?.toI8nString(context);

    return SeasonGrandPrixBetPreviewItem(
      label: context.str.safetyCar,
      betStatus: bet?.status,
      betChild:
          betSafetyCarStr != null
              ? BodyMedium(betSafetyCarStr)
              : const GrandPrixBetNoDataField(),
      resultsChild:
          resultsSafetyCarStr != null
              ? Text(resultsSafetyCarStr)
              : const GrandPrixBetNoDataField(),
      points: bet?.points,
    );
  }
}

class _RedFlag extends StatelessWidget {
  const _RedFlag();

  @override
  Widget build(BuildContext context) {
    final BooleanBet? bet = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) => cubit.state.raceRedFlagBet,
    );
    final String? betRedFlagStr = bet?.betValue?.toI8nString(context);
    final String? resultsRedFlagStr = bet?.resultValue?.toI8nString(context);

    return SeasonGrandPrixBetPreviewItem(
      label: context.str.redFlag,
      betStatus: bet?.status,
      betChild:
          betRedFlagStr != null
              ? Text(betRedFlagStr)
              : const GrandPrixBetNoDataField(),
      resultsChild:
          resultsRedFlagStr != null
              ? Text(resultsRedFlagStr)
              : const GrandPrixBetNoDataField(),
      points: bet?.points,
    );
  }
}

class _PointsSummary extends StatelessWidget {
  const _PointsSummary();

  @override
  Widget build(BuildContext context) {
    final RaceBetPoints? racePoints = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) =>
          cubit.state.seasonGrandPrixBetPoints?.raceBetPoints,
    );

    return SeasonGrandPrixBetPreviewPointsSummary(
      details: [
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: context.str.seasonGrandPrixBetPreviewPositions,
          value: racePoints?.podiumAndP10,
        ),
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: context.str.seasonGrandPrixBetPreviewPositionsMultiplier,
          value: racePoints?.podiumAndP10Multiplier,
        ),
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: context.str.seasonGrandPrixBetPreviewFastestLap,
          value: racePoints?.fastestLap,
        ),
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: context.str.seasonGrandPrixBetPreviewDnf,
          value: racePoints?.totalDnf,
        ),
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: context.str.seasonGrandPrixBetPreviewDnfMultiplier,
          value: racePoints?.dnfMultiplier,
        ),
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: context.str.seasonGrandPrixBetPreviewOther,
          value: racePoints?.safetyCarAndRedFlag,
        ),
      ],
      totalPoints: racePoints?.total,
    );
  }
}

extension _BoolExtensions on bool {
  String toI8nString(BuildContext context) => switch (this) {
    true => context.str.yes,
    false => context.str.no,
  };
}
