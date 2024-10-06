import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../../component/empty_content_info_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/bets_cubit.dart';
import '../cubit/bets_state.dart';
import 'bets_list_of_bets.dart';

class BetsBody extends StatelessWidget {
  const BetsBody({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: Simplify it and add new status to cubit
    final bool isCubitLoading = context.select(
      (BetsCubit cubit) => cubit.state.status.isLoading,
    );
    final double? totalPoints = context.select(
      (BetsCubit cubit) => cubit.state.totalPoints,
    );
    final List<GrandPrixWithPoints>? grandPrixesWithPoints = context.select(
      (BetsCubit cubit) => cubit.state.grandPrixesWithPoints,
    );

    return isCubitLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : totalPoints == null || grandPrixesWithPoints == null
            ? EmptyContentInfo(
                title: context.str.betsNoBetsTitle,
                message: context.str.betsNoBetsMessage,
              )
            : const BetsListOfBets();
  }
}
