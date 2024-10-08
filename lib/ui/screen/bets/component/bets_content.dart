import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/empty_content_info_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/bets_cubit.dart';
import '../cubit/bets_state.dart';
import 'bets_list_of_bets.dart';

class BetsContent extends StatelessWidget {
  const BetsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final BetsStateStatus cubitStatus = context.select(
      (BetsCubit cubit) => cubit.state.status,
    );

    return cubitStatus.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : cubitStatus.areNoBets
            ? EmptyContentInfo(
                title: context.str.betsNoBetsTitle,
                message: context.str.betsNoBetsMessage,
              )
            : const BetsListOfBets();
  }
}
