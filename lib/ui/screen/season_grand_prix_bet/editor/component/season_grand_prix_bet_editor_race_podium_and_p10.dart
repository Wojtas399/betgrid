import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../extensions/build_context_extensions.dart';
import '../cubit/season_grand_prix_bet_editor_cubit.dart';
import 'season_grand_prix_bet_editor_driver_field.dart';

class SeasonGrandPrixBetEditorRacePodiumAndP10 extends StatelessWidget {
  const SeasonGrandPrixBetEditorRacePodiumAndP10({super.key});

  @override
  Widget build(BuildContext context) {
    final String? p1SeasonDriverId = context.select(
      (SeasonGrandPrixBetEditorCubit cubit) =>
          cubit.state.raceForm.p1SeasonDriverId,
    );
    final String? p2SeasonDriverId = context.select(
      (SeasonGrandPrixBetEditorCubit cubit) =>
          cubit.state.raceForm.p2SeasonDriverId,
    );
    final String? p3SeasonDriverId = context.select(
      (SeasonGrandPrixBetEditorCubit cubit) =>
          cubit.state.raceForm.p3SeasonDriverId,
    );
    final String? p10SeasonDriverId = context.select(
      (SeasonGrandPrixBetEditorCubit cubit) =>
          cubit.state.raceForm.p10SeasonDriverId,
    );
    final List<String> allSelectedSeasonDriverIdsFromPodium = [
      if (p1SeasonDriverId != null) p1SeasonDriverId,
      if (p2SeasonDriverId != null) p2SeasonDriverId,
      if (p3SeasonDriverId != null) p3SeasonDriverId,
      if (p10SeasonDriverId != null) p10SeasonDriverId,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeasonGrandPrixBetEditorDriverField(
          label: 'P1',
          labelColor: context.customColors?.p1,
          selectedSeasonDriverId: p1SeasonDriverId,
          allSelectedSeasonDriverIds: allSelectedSeasonDriverIdsFromPodium,
          onSeasonDriverSelected:
              context
                  .read<SeasonGrandPrixBetEditorCubit>()
                  .onRaceP1DriverChanged,
        ),
        SeasonGrandPrixBetEditorDriverField(
          label: 'P2',
          labelColor: context.customColors?.p2,
          selectedSeasonDriverId: p2SeasonDriverId,
          allSelectedSeasonDriverIds: allSelectedSeasonDriverIdsFromPodium,
          onSeasonDriverSelected:
              context
                  .read<SeasonGrandPrixBetEditorCubit>()
                  .onRaceP2DriverChanged,
        ),
        SeasonGrandPrixBetEditorDriverField(
          label: 'P3',
          labelColor: context.customColors?.p3,
          selectedSeasonDriverId: p3SeasonDriverId,
          allSelectedSeasonDriverIds: allSelectedSeasonDriverIdsFromPodium,
          onSeasonDriverSelected:
              context
                  .read<SeasonGrandPrixBetEditorCubit>()
                  .onRaceP3DriverChanged,
        ),
        SeasonGrandPrixBetEditorDriverField(
          label: 'P10',
          selectedSeasonDriverId: p10SeasonDriverId,
          allSelectedSeasonDriverIds: allSelectedSeasonDriverIdsFromPodium,
          onSeasonDriverSelected:
              context
                  .read<SeasonGrandPrixBetEditorCubit>()
                  .onRaceP10DriverChanged,
        ),
      ],
    );
  }
}
