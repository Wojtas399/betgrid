import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/grand_prix_bet_points.dart';
import '../../../component/driver_description_component.dart';
import '../../../component/no_text_component.dart';
import '../../../component/padding/padding_components.dart';
import '../../../config/theme/custom_colors.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/grand_prix_bet_cubit.dart';
import '../cubit/grand_prix_bet_state.dart';
import 'grand_prix_bet_item.dart';
import 'grand_prix_bet_section_title.dart';
import 'grand_prix_points_summary.dart';

class GrandPrixBetQualifications extends StatelessWidget {
  const GrandPrixBetQualifications({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _Title(),
      children: [
        const Padding16(
          child: Column(
            children: [
              _Bets(),
              _PointsSummary(),
            ],
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double? qualiPoints = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.grandPrixBetPoints?.qualiBetPoints?.totalPoints,
    );

    return GrandPrixBetSectionTitle(
      title: context.str.qualifications,
      points: qualiPoints,
    );
  }
}

class _Bets extends StatelessWidget {
  const _Bets();

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
                    betChild: bet.betDriver != null
                        ? DriverDescription(
                            name: bet.betDriver!.name,
                            surname: bet.betDriver!.surname,
                            number: bet.betDriver!.number,
                            teamColor: bet.betDriver!.team.hexColor,
                          )
                        : const NoText(),
                    resultsChild: bet.resultDriver != null
                        ? DriverDescription(
                            name: bet.resultDriver!.name,
                            surname: bet.resultDriver!.surname,
                            number: bet.resultDriver!.number,
                            teamColor: bet.resultDriver!.team.hexColor,
                          )
                        : const NoText(),
                    points: bet.points,
                  );
                },
              ),
            ],
          )
        : const SizedBox();
  }
}

class _PointsSummary extends StatelessWidget {
  const _PointsSummary();

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
