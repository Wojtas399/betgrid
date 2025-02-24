import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/custom_card_component.dart';
import '../../../../component/gap/gap_vertical.dart';
import '../../../../component/padding/padding_components.dart';
import '../../../../component/text_component.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/season_grand_prix_bet_editor_cubit.dart';
import '../cubit/season_grand_prix_bet_editor_state.dart';
import 'season_grand_prix_bet_editor_gp_bet_info.dart';
import 'season_grand_prix_bet_editor_quali.dart';
import 'season_grand_prix_bet_editor_race.dart';

class SeasonGrandPrixBetEditorBody extends StatelessWidget {
  const SeasonGrandPrixBetEditorBody({super.key});

  @override
  Widget build(BuildContext context) {
    final SeasonGrandPrixBetEditorStateStatus cubitStatus = context.select(
      (SeasonGrandPrixBetEditorCubit cubit) => cubit.state.status,
    );

    return cubitStatus.isInitial
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Padding8(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GapVertical16(),
                const SeasonGrandPrixBetEditorGpBetInfo(),
                const GapVertical24(),
                _Section(
                  title: context.str.qualifications,
                  subtitle:
                      context.str.grandPrixBetEditorQualificationDescription,
                  body: const SeasonGrandPrixBetEditorQuali(),
                ),
                const GapVertical24(),
                _Section(
                  title: context.str.race,
                  subtitle: context.str.grandPrixBetEditorRaceDescription,
                  body: const SeasonGrandPrixBetEditorRace(),
                ),
              ],
            ),
          ),
        );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;

  const _Section({
    required this.title,
    required this.subtitle,
    required this.body,
  });

  @override
  Widget build(BuildContext context) => CustomCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleLarge(title, fontWeight: FontWeight.bold),
        const GapVertical4(),
        BodyMedium(subtitle),
        const GapVertical16(),
        body,
      ],
    ),
  );
}
