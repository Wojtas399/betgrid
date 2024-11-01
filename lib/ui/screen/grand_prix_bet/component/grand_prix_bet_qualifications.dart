import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/grand_prix_bet_points.dart';
import '../../../config/theme/custom_colors.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/grand_prix_bet_cubit.dart';
import 'grand_prix_bet_driver_description.dart';
import 'grand_prix_bet_item.dart';
import 'grand_prix_points_summary.dart';

class GrandPrixBetQualifications extends StatelessWidget {
  const GrandPrixBetQualifications({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Positions(),
          _Summary(),
        ],
      );
}

class _Positions extends StatelessWidget {
  const _Positions();

  @override
  Widget build(BuildContext context) {
    final List<String?>? betStandings = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBet?.qualiStandingsByDriverIds,
    );
    final List<String?>? resultsStandings = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixResults?.qualiStandingsByDriverIds,
    );
    final QualiBetPoints? qualiPointsDetails = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.qualiBetPoints,
    );
    final List<double>? positionsPoints = qualiPointsDetails != null
        ? [
            qualiPointsDetails.q3P1Points,
            qualiPointsDetails.q3P2Points,
            qualiPointsDetails.q3P3Points,
            qualiPointsDetails.q3P4Points,
            qualiPointsDetails.q3P5Points,
            qualiPointsDetails.q3P6Points,
            qualiPointsDetails.q3P7Points,
            qualiPointsDetails.q3P8Points,
            qualiPointsDetails.q3P9Points,
            qualiPointsDetails.q3P10Points,
            qualiPointsDetails.q2P11Points,
            qualiPointsDetails.q2P12Points,
            qualiPointsDetails.q2P13Points,
            qualiPointsDetails.q2P14Points,
            qualiPointsDetails.q2P15Points,
            qualiPointsDetails.q1P16Points,
            qualiPointsDetails.q1P17Points,
            qualiPointsDetails.q1P18Points,
            qualiPointsDetails.q1P19Points,
            qualiPointsDetails.q1P20Points,
          ]
        : null;
    final CustomColors? customColors = context.customColors;

    return Column(
      children: [
        ...List.generate(
          20,
          (int itemIndex) => GrandPrixBetItem(
            label: 'P${itemIndex + 1}',
            labelColor: switch (itemIndex) {
              0 => customColors?.p1,
              1 => customColors?.p2,
              2 => customColors?.p3,
              _ => null,
            },
            betChild: GrandPrixBetDriverDescription(
              driverId: betStandings?[itemIndex],
            ),
            resultsChild: GrandPrixBetDriverDescription(
              driverId: resultsStandings?[itemIndex],
            ),
            points: positionsPoints?[itemIndex],
          ),
        )
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary();

  @override
  Widget build(BuildContext context) {
    final QualiBetPoints? qualiPointsDetails = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.qualiBetPoints,
    );

    return GrandPrixBetPointsSummary(
      details: [
        GrandPrixPointsSummaryDetail(
          label: 'Q1',
          value: qualiPointsDetails?.q1Points,
        ),
        GrandPrixPointsSummaryDetail(
          label: 'Q2',
          value: qualiPointsDetails?.q2Points,
        ),
        GrandPrixPointsSummaryDetail(
          label: 'Q3',
          value: qualiPointsDetails?.q3Points,
        ),
        GrandPrixPointsSummaryDetail(
          label: '${context.str.grandPrixBetMultiplier} Q1',
          value: qualiPointsDetails?.q1Multiplier,
        ),
        GrandPrixPointsSummaryDetail(
          label: '${context.str.grandPrixBetMultiplier} Q2',
          value: qualiPointsDetails?.q2Multiplier,
        ),
        GrandPrixPointsSummaryDetail(
          label: '${context.str.grandPrixBetMultiplier} Q3',
          value: qualiPointsDetails?.q3Multiplier,
        ),
        GrandPrixPointsSummaryDetail(
          label: context.str.grandPrixBetMultiplier,
          value: qualiPointsDetails?.multiplier,
        ),
      ],
      totalPoints: qualiPointsDetails?.totalPoints,
    );
  }
}
