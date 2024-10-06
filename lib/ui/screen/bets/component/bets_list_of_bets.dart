import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../../component/sliver_grand_prixes_list_component.dart';
import '../../../component/sliver_player_total_points_component.dart';
import '../../../config/router/app_router.dart';
import '../cubit/bets_cubit.dart';

class BetsListOfBets extends StatelessWidget {
  const BetsListOfBets({super.key});

  @override
  Widget build(BuildContext context) => const CustomScrollView(
        slivers: [
          _TotalPoints(),
          _GrandPrixes(),
        ],
      );
}

class _TotalPoints extends StatelessWidget {
  const _TotalPoints();

  @override
  Widget build(BuildContext context) {
    final double? totalPoints = context.select(
      (BetsCubit cubit) => cubit.state.totalPoints,
    );

    return SliverPlayerTotalPoints(
      points: totalPoints!,
    );
  }
}

class _GrandPrixes extends StatelessWidget {
  const _GrandPrixes();

  void _onGrandPrixPressed(String grandPrixId, BuildContext context) {
    final String? loggedUserId = context.read<BetsCubit>().state.loggedUserId;
    if (loggedUserId != null) {
      context.navigateTo(
        GrandPrixBetRoute(
          grandPrixId: grandPrixId,
          playerId: loggedUserId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<GrandPrixWithPoints>? grandPrixesWithPoints = context.select(
      (BetsCubit cubit) => cubit.state.grandPrixesWithPoints,
    );

    return SliverGrandPrixesList(
      grandPrixesWithPoints: grandPrixesWithPoints!,
      onGrandPrixPressed: (String grandPrixId) =>
          _onGrandPrixPressed(grandPrixId, context),
    );
  }
}
