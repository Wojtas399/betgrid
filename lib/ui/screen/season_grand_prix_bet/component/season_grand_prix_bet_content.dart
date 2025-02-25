import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/season_grand_prix_bet_cubit.dart';
import '../cubit/season_grand_prix_bet_state.dart';
import 'season_grand_prix_bet_editor_content.dart';
import 'season_grand_prix_bet_preview_content.dart';

class SeasonGrandPrixBetContent extends StatelessWidget {
  const SeasonGrandPrixBetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final SeasonGrandPrixBetState state =
        context.watch<SeasonGrandPrixBetCubit>().state;

    return state.map(
      initial: (_) => const _LoadingContent(),
      editor: (_) => const SeasonGrandPrixBetEditorContent(),
      preview: (_) => const SeasonGrandPrixBetPreviewContent(),
      seasonGrandPrixNotFound:
          (_) => const Center(child: Text('Season Grand Prix Not Found')),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
