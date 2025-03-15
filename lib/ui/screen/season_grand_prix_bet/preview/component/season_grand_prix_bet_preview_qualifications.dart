import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../model/season_grand_prix_bet_points.dart';
import '../../../../component/driver_description_component.dart';
import '../../../../component/no_text_component.dart';
import '../../../../component/padding/padding_components.dart';
import '../../../../config/theme/custom_colors.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/season_grand_prix_bet_preview_cubit.dart';
import '../cubit/season_grand_prix_bet_preview_state.dart';
import 'season_grand_prix_bet_preview_item.dart';
import 'season_grand_prix_bet_preview_section_title.dart';
import 'season_grand_prix_preview_points_summary.dart';

class SeasonGrandPrixBetPreviewQualifications extends StatelessWidget {
  const SeasonGrandPrixBetPreviewQualifications({super.key});

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
    final double? qualiPoints = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) =>
          cubit.state.seasonGrandPrixBetPoints?.qualiBetPoints?.total,
    );

    return SeasonGrandPrixBetPreviewSectionTitle(
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
      (SeasonGrandPrixBetPreviewCubit cubit) => cubit.state.qualiBets,
    );
    final CustomColors? customColors = context.customColors;

    return qualiStandingsBets != null
        ? Column(
          children: [
            ...List.generate(qualiStandingsBets.length, (int positionIndex) {
              final bet = qualiStandingsBets[positionIndex];

              return SeasonGrandPrixBetPreviewItem(
                label: 'P${positionIndex + 1}',
                labelColor: switch (positionIndex) {
                  0 => customColors?.p1,
                  1 => customColors?.p2,
                  2 => customColors?.p3,
                  _ => null,
                },
                betStatus: bet.status,
                betChild:
                    bet.betDriver != null
                        ? DriverDescription(driverDetails: bet.betDriver!)
                        : const NoText(),
                resultsChild:
                    bet.resultDriver != null
                        ? DriverDescription(driverDetails: bet.resultDriver!)
                        : const NoText(),
                points: bet.points,
              );
            }),
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
      (SeasonGrandPrixBetPreviewCubit cubit) =>
          cubit.state.seasonGrandPrixBetPoints?.qualiBetPoints,
    );

    return SeasonGrandPrixBetPreviewPointsSummary(
      details: [
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: 'Q1',
          value: qualiPointsDetails?.totalQ1,
        ),
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: 'Q2',
          value: qualiPointsDetails?.totalQ2,
        ),
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: 'Q3',
          value: qualiPointsDetails?.totalQ3,
        ),
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: '${context.str.seasonGrandPrixBetPreviewMultiplier} Q1',
          value: qualiPointsDetails?.q1Multiplier,
        ),
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: '${context.str.seasonGrandPrixBetPreviewMultiplier} Q2',
          value: qualiPointsDetails?.q2Multiplier,
        ),
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: '${context.str.seasonGrandPrixBetPreviewMultiplier} Q3',
          value: qualiPointsDetails?.q3Multiplier,
        ),
        SeasonGrandPrixBetPreviewPointsSummaryDetail(
          label: context.str.seasonGrandPrixBetPreviewMultiplier,
          value: qualiPointsDetails?.multiplier,
        ),
      ],
      totalPoints: qualiPointsDetails?.total,
    );
  }
}
