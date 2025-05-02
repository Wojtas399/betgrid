import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/text_component.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../../../../extensions/duration_extensions.dart';
import '../../cubit/season_grand_prix_bet_cubit.dart';
import '../../cubit/season_grand_prix_bet_state.dart';

class SeasonGrandPrixBetEditorGpBetInfo extends StatelessWidget {
  const SeasonGrandPrixBetEditorGpBetInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.0,
        children: [
          const _RoundNumber(),
          const _GrandPrixName(),
          Row(
            children: [
              BodyMedium('${context.str.seasonGrandPrixBetsEndBettingTime} '),
              const _DurationToStart(),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundNumber extends StatelessWidget {
  const _RoundNumber();

  @override
  Widget build(BuildContext context) {
    final int? roundNumber = context.select((SeasonGrandPrixBetCubit cubit) {
      final SeasonGrandPrixBetState state = cubit.state;
      return state is SeasonGrandPrixBetStateEditor ? state.roundNumber : null;
    });

    return BodyMedium(
      '${context.str.round} $roundNumber',
      fontWeight: FontWeight.w300,
    );
  }
}

class _GrandPrixName extends StatelessWidget {
  const _GrandPrixName();

  @override
  Widget build(BuildContext context) {
    final String? grandPrixName = context.select((
      SeasonGrandPrixBetCubit cubit,
    ) {
      final SeasonGrandPrixBetState state = cubit.state;
      return state is SeasonGrandPrixBetStateEditor
          ? state.grandPrixName
          : null;
    });

    return TitleLarge(grandPrixName ?? '', fontWeight: FontWeight.bold);
  }
}

class _DurationToStart extends StatelessWidget {
  const _DurationToStart();

  @override
  Widget build(BuildContext context) {
    final Duration? durationToStart = context.select((
      SeasonGrandPrixBetCubit cubit,
    ) {
      final SeasonGrandPrixBetState state = cubit.state;
      return state is SeasonGrandPrixBetStateEditor
          ? state.durationToStart
          : null;
    });

    return BodyMedium(
      durationToStart?.toUIDuration() ?? '',
      fontWeight: FontWeight.bold,
    );
  }
}
