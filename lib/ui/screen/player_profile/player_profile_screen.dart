import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../../model/player.dart';
import '../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../component/avatar_component.dart';
import '../../component/sliver_grand_prixes_list_component.dart';
import '../../component/sliver_player_total_points_component.dart';
import '../../component/text_component.dart';
import '../../config/router/app_router.dart';
import '../../extensions/build_context_extensions.dart';
import 'cubit/player_profile_cubit.dart';

@RoutePage()
class PlayerProfileScreen extends StatelessWidget {
  final String playerId;

  const PlayerProfileScreen({
    super.key,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) =>
            getIt.get<PlayerProfileCubit>()..initialize(playerId: playerId),
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              _AppBar.build(
                backgroundColor: context.colorScheme.primary,
                foregroundColor: Theme.of(context).canvasColor,
              ),
              const _TotalPoints(),
              const _GrandPrixes(),
            ],
          ),
        ),
      );
}

class _AppBar extends SliverAppBar {
  const _AppBar({
    super.backgroundColor,
    super.foregroundColor,
    super.flexibleSpace,
  }) : super(
          pinned: true,
          expandedHeight: 300,
          surfaceTintColor: Colors.transparent,
        );

  factory _AppBar.build({
    required Color backgroundColor,
    required Color foregroundColor,
  }) =>
      _AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        flexibleSpace: Builder(
          builder: (BuildContext context) {
            final Player? player = context.select(
              (PlayerProfileCubit cubit) => cubit.state.player,
            );

            return player != null
                ? FlexibleSpaceBar(
                    title: TitleLarge(
                      player.username,
                      color: Theme.of(context).canvasColor,
                    ),
                    centerTitle: true,
                    titlePadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 0,
                    ),
                    background: LayoutBuilder(
                      builder: (_, BoxConstraints constraints) {
                        final double avatarSize = constraints.maxHeight * 0.55;

                        return Center(
                          child: SizedBox(
                            width: avatarSize,
                            height: avatarSize,
                            child: Hero(
                              tag: player.id,
                              child: Avatar(
                                avatarUrl: player.avatarUrl,
                                username: player.username,
                                usernameFontSize: 56,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const CircularProgressIndicator();
          },
        ),
      );
}

class _TotalPoints extends StatelessWidget {
  const _TotalPoints();

  @override
  Widget build(BuildContext context) {
    final isCubitLoading = context.select(
      (PlayerProfileCubit cubit) => cubit.state.isLoading,
    );
    final totalPoints = context.select(
      (PlayerProfileCubit cubit) => cubit.state.totalPoints,
    );

    return SliverPlayerTotalPoints(
      points: totalPoints ?? 0.0, //TODO
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
      (PlayerProfileCubit cubit) => cubit.state.isLoading,
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
