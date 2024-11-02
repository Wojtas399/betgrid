import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/grand_prix_bet_points.dart';
import '../../../component/driver_description_component.dart';
import '../../../config/theme/custom_colors.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/grand_prix_bet_cubit.dart';
import '../cubit/grand_prix_bet_state.dart';
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
    final List<SingleDriverBet>? qualiStandingsBets = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.qualiBets,
    );
    final CustomColors? customColors = context.customColors;

    return qualiStandingsBets != null
        ? Column(
            children: [
              ...List.generate(
                qualiStandingsBets.length,
                (int positionIndex) {
                  final bet = qualiStandingsBets[positionIndex];

                  return GrandPrixBetItem(
                    label: 'P${positionIndex + 1}',
                    labelColor: switch (positionIndex) {
                      0 => customColors?.p1,
                      1 => customColors?.p2,
                      2 => customColors?.p3,
                      _ => null,
                    },
                    betStatus: bet.status,
                    betChild: DriverDescription(driver: bet.betDriver),
                    resultsChild: DriverDescription(driver: bet.resultDriver),
                    points: bet.points,
                  );
                },
              ),
            ],
          )
        : const SizedBox();
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
