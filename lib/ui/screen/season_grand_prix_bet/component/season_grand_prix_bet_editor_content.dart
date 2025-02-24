import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../editor/component/season_grand_prix_bet_editor_app_bar.dart';
import '../editor/cubit/season_grand_prix_bet_editor_cubit.dart';
import '../cubit/season_grand_prix_bet_cubit.dart';
import '../editor/component/season_grand_prix_bet_editor_body.dart';

class SeasonGrandPrixBetEditorContent extends StatelessWidget {
  const SeasonGrandPrixBetEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    final SeasonGrandPrixBetCubit cubit =
        context.read<SeasonGrandPrixBetCubit>();

    return BlocProvider(
      create:
          (_) => getIt<SeasonGrandPrixBetEditorCubit>(
            param1: cubit.season,
            param2: cubit.seasonGrandPrixId,
          )..initialize(),
      child: const Scaffold(
        appBar: SeasonGrandPrixBetEditorAppBar(),
        body: SafeArea(child: SeasonGrandPrixBetEditorBody()),
      ),
    );
  }
}
