import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../component/sliver_grand_prixes_list_component.dart';
import '../../component/sliver_player_total_points_component.dart';
import '../../config/router/app_router.dart';
import 'cubit/bets_cubit.dart';
import 'cubit/bets_state.dart';

@RoutePage()
class BetsScreen extends StatelessWidget {
  const BetsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<BetsCubit>()..initialize(),
        child: const CustomScrollView(
          slivers: [
            _TotalPoints(),
            _GrandPrixes(),
          ],
        ),
      );
}

class _TotalPoints extends StatelessWidget {
  const _TotalPoints();

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.select(
      (BetsCubit cubit) => cubit.state.status == BetsStateStatus.loading,
    );
    final double totalPoints = context.select(
      (BetsCubit cubit) => cubit.state.totalPoints,
    );

    return SliverPlayerTotalPoints(
      points: totalPoints,
      isLoading: isLoading,
    );
  }
}

class _GrandPrixes extends StatelessWidget {
  const _GrandPrixes();

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.select(
      (BetsCubit cubit) => cubit.state.status == BetsStateStatus.loading,
    );
    final String loggedUserId = context.select(
      (BetsCubit cubit) => cubit.state.loggedUserId,
    );
    final List<GrandPrixWithPoints> grandPrixesWithPoints = context.select(
      (BetsCubit cubit) => cubit.state.grandPrixesWithPoints,
    );

    return SliverGrandPrixesList(
      grandPrixesWithPoints: grandPrixesWithPoints,
      onGrandPrixPressed: (String grandPrixId) {
        context.navigateTo(
          GrandPrixBetRoute(
            grandPrixId: grandPrixId,
            playerId: loggedUserId,
          ),
        );
      },
      isLoading: isLoading,
    );
  }
}
