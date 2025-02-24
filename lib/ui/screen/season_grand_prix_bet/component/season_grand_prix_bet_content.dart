import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/season_grand_prix_bet_cubit.dart';
import '../cubit/season_grand_prix_bet_state.dart';

class SeasonGrandPrixBetContent extends StatelessWidget {
  const SeasonGrandPrixBetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _Body());
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final SeasonGrandPrixBetState state =
        context.watch<SeasonGrandPrixBetCubit>().state;

    return state.when(
      initial: () => const Center(child: CircularProgressIndicator()),
      editor: () => const Center(child: Text('Editor')),
      preview: () => const Center(child: Text('Preview')),
      seasonGrandPrixNotFound:
          () => const Center(child: Text('Season Grand Prix Not Found')),
    );
  }
}
