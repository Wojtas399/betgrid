import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../../component/sliver_grand_prixes_list_component.dart';
import '../../../component/sliver_player_total_points_component.dart';
import '../../../config/router/app_router.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/player_profile_cubit.dart';
import '../cubit/player_profile_state.dart';
import 'player_profile_app_bar.dart';

class PlayerProfileContent extends StatelessWidget {
  const PlayerProfileContent({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: _Body(),
      );
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final bool isCubitLoading = context.select(
      (PlayerProfileCubit cubit) => cubit.state.status.isLoading,
    );

    return isCubitLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : CustomScrollView(
            slivers: [
              PlayerProfileAppBar.build(
                backgroundColor: context.colorScheme.primary,
                foregroundColor: Theme.of(context).canvasColor,
              ),
              const _TotalPoints(),
              const _GrandPrixes(),
            ],
          );
  }
}

class _TotalPoints extends StatelessWidget {
  const _TotalPoints();

  @override
  Widget build(BuildContext context) {
    final isCubitLoading = context.select(
      (PlayerProfileCubit cubit) => cubit.state.status.isLoading,
    );
    final double? totalPoints = context.select(
      (PlayerProfileCubit cubit) => cubit.state.totalPoints,
    );

    return SliverPlayerTotalPoints(
      points: totalPoints!,
      isLoading: isCubitLoading,
    );
  }
}

class _GrandPrixes extends StatelessWidget {
  const _GrandPrixes();

  void _onGrandPrixPressed(String grandPrixId, BuildContext context) {
    final String? playerId =
        context.read<PlayerProfileCubit>().state.player?.id;
    if (playerId != null) {
      context.navigateTo(
        GrandPrixBetRoute(
          grandPrixId: grandPrixId,
          playerId: playerId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCubitLoading = context.select(
      (PlayerProfileCubit cubit) => cubit.state.status.isLoading,
    );
    final List<GrandPrixWithPoints> grandPrixesWithPoints = context.select(
      (PlayerProfileCubit cubit) => cubit.state.grandPrixesWithPoints,
    );

    return SliverGrandPrixesList(
      grandPrixesWithPoints: grandPrixesWithPoints,
      onGrandPrixPressed: (String grandPrixId) =>
          _onGrandPrixPressed(grandPrixId, context),
      isLoading: isCubitLoading,
    );
  }
}
