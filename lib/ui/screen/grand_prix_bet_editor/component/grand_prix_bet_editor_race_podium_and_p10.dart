import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extensions/build_context_extensions.dart';
import '../cubit/grand_prix_bet_editor_cubit.dart';
import 'grand_prix_bet_editor_driver_field.dart';

class GrandPrixBetEditorRacePodiumAndP10 extends StatelessWidget {
  const GrandPrixBetEditorRacePodiumAndP10({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _P1(),
          _P2(),
          _P3(),
          _P10(),
        ],
      );
}

class _P1 extends StatelessWidget {
  const _P1();

  @override
  Widget build(BuildContext context) {
    final String? driverId = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.raceForm.p1DriverId,
    );

    return GrandPrixBetEditorDriverField(
      label: 'P1',
      labelColor: context.customColors?.p1,
      selectedDriverId: driverId,
      onDriverSelected:
          context.read<GrandPrixBetEditorCubit>().onRaceP1DriverChanged,
    );
  }
}

class _P2 extends StatelessWidget {
  const _P2();

  @override
  Widget build(BuildContext context) {
    final String? driverId = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.raceForm.p2DriverId,
    );

    return GrandPrixBetEditorDriverField(
      label: 'P2',
      labelColor: context.customColors?.p2,
      selectedDriverId: driverId,
      onDriverSelected:
          context.read<GrandPrixBetEditorCubit>().onRaceP2DriverChanged,
    );
  }
}

class _P3 extends StatelessWidget {
  const _P3();

  @override
  Widget build(BuildContext context) {
    final String? driverId = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.raceForm.p3DriverId,
    );

    return GrandPrixBetEditorDriverField(
      label: 'P3',
      labelColor: context.customColors?.p3,
      selectedDriverId: driverId,
      onDriverSelected:
          context.read<GrandPrixBetEditorCubit>().onRaceP3DriverChanged,
    );
  }
}

class _P10 extends StatelessWidget {
  const _P10();

  @override
  Widget build(BuildContext context) {
    final String? driverId = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.raceForm.p10DriverId,
    );

    return GrandPrixBetEditorDriverField(
      label: 'P10',
      selectedDriverId: driverId,
      onDriverSelected:
          context.read<GrandPrixBetEditorCubit>().onRaceP10DriverChanged,
    );
  }
}
