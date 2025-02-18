import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/empty_content_info_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/season_grand_prix_bets_cubit.dart';
import '../cubit/season_grand_prix_bets_state.dart';
import 'season_grand_prix_bets_list_of_bets.dart';

class SeasonGrandPrixBetsBody extends StatelessWidget {
  const SeasonGrandPrixBetsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final SeasonGrandPrixBetsStateStatus cubitStatus = context.select(
      (SeasonGrandPrixBetsCubit cubit) => cubit.state.status,
    );

    return cubitStatus.isLoading
        ? const Center(child: CircularProgressIndicator())
        : cubitStatus.areNoBets
        ? EmptyContentInfo(
          title: context.str.betsNoBetsTitle,
          message: context.str.betsNoBetsMessage,
        )
        : const SeasonGrandPrixBetsListOfBets();
  }
}
