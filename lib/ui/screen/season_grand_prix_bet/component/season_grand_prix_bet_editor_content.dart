import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../cubit/season_grand_prix_bet_state.dart';
import '../editor/component/season_grand_prix_bet_editor_app_bar.dart';
import '../editor/cubit/season_grand_prix_bet_editor_cubit.dart';
import '../cubit/season_grand_prix_bet_cubit.dart';
import '../editor/component/season_grand_prix_bet_editor_body.dart';

class SeasonGrandPrixBetEditorContent extends StatelessWidget {
  const SeasonGrandPrixBetEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    final SeasonGrandPrixBetState state =
        context.read<SeasonGrandPrixBetCubit>().state;

    int? season;
    String? seasonGrandPrixId;
    if (state is SeasonGrandPrixBetStateEditor) {
      season = state.season;
      seasonGrandPrixId = state.seasonGrandPrixId;
    }

    return season != null && seasonGrandPrixId != null
        ? BlocProvider(
          create:
              (_) => getIt<SeasonGrandPrixBetEditorCubit>(
                param1: season,
                param2: seasonGrandPrixId,
              )..initialize(),
          child: const Scaffold(
            appBar: SeasonGrandPrixBetEditorAppBar(),
            body: SafeArea(child: SeasonGrandPrixBetEditorBody()),
          ),
        )
        : const Placeholder();
  }
}
