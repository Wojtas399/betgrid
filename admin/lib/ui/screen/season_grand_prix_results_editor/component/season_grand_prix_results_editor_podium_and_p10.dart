import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extensions/build_context_extensions.dart';
import '../cubit/season_grand_prix_results_editor_cubit.dart';
import '../cubit/season_grand_prix_results_editor_state.dart';
import 'season_grand_prix_results_editor_driver_field.dart';

class SeasonGrandPrixResultsEditorPodiumAndP10 extends StatelessWidget {
  const SeasonGrandPrixResultsEditorPodiumAndP10({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_P1(), _P2(), _P3(), _P10()],
  );
}

class _P1 extends StatelessWidget {
  const _P1();

  @override
  Widget build(BuildContext context) {
    final String? p1SeasonDriverId = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .raceForm
              .p1SeasonDriverId,
    );

    return SeasonGrandPrixResultsEditorDriverField(
      label: 'P1',
      labelColor: context.customColors?.p1,
      selectedDriverId: p1SeasonDriverId,
      onDriverSelected:
          context
              .read<SeasonGrandPrixResultsEditorCubit>()
              .onRaceP1DriverChanged,
    );
  }
}

class _P2 extends StatelessWidget {
  const _P2();

  @override
  Widget build(BuildContext context) {
    final String? p2SeasonDriverId = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .raceForm
              .p2SeasonDriverId,
    );

    return SeasonGrandPrixResultsEditorDriverField(
      label: 'P2',
      labelColor: context.customColors?.p2,
      selectedDriverId: p2SeasonDriverId,
      onDriverSelected:
          context
              .read<SeasonGrandPrixResultsEditorCubit>()
              .onRaceP2DriverChanged,
    );
  }
}

class _P3 extends StatelessWidget {
  const _P3();

  @override
  Widget build(BuildContext context) {
    final String? p3SeasonDriverId = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .raceForm
              .p3SeasonDriverId,
    );

    return SeasonGrandPrixResultsEditorDriverField(
      label: 'P3',
      labelColor: context.customColors?.p3,
      selectedDriverId: p3SeasonDriverId,
      onDriverSelected:
          context
              .read<SeasonGrandPrixResultsEditorCubit>()
              .onRaceP3DriverChanged,
    );
  }
}

class _P10 extends StatelessWidget {
  const _P10();

  @override
  Widget build(BuildContext context) {
    final String? p10SeasonDriverId = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .raceForm
              .p10SeasonDriverId,
    );

    return SeasonGrandPrixResultsEditorDriverField(
      label: 'P10',
      selectedDriverId: p10SeasonDriverId,
      onDriverSelected:
          context
              .read<SeasonGrandPrixResultsEditorCubit>()
              .onRaceP10DriverChanged,
    );
  }
}
