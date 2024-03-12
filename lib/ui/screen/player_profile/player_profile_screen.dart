import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/player.dart';
import '../../component/avatar_component.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text/display.dart';
import '../../component/text/headline.dart';
import '../../component/text/title.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/player_points_provider.dart';
import 'player_profile_grand_prixes.dart';

@RoutePage()
class PlayerProfileScreen extends StatelessWidget {
  final Player player;

  const PlayerProfileScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).canvasColor,
            player: player,
            context: context,
          ),
          _TotalPoints(playerId: player.id),
          PlayerProfileGrandPrixes(playerId: player.id),
        ],
      ),
    );
  }
}

class _AppBar extends SliverAppBar {
  _AppBar({
    required Player player,
    required BuildContext context,
    Color? backgroundColor,
    Color? foregroundColor,
  }) : super(
          pinned: true,
          expandedHeight: 300,
          surfaceTintColor: Colors.transparent,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          flexibleSpace: FlexibleSpaceBar(
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
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
}

class _TotalPoints extends SliverPadding {
  _TotalPoints({required String playerId})
      : super(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          sliver: SliverToBoxAdapter(
            child: Builder(
              builder: (BuildContext context) {
                return Column(
                  children: [
                    HeadlineMedium(
                      context.str.grandPrixBetPoints,
                      fontWeight: FontWeight.bold,
                    ),
                    const GapVertical8(),
                    Consumer(
                      builder: (_, ref, __) {
                        final totalPoints = ref.watch(
                          playerPointsProvider(playerId: playerId),
                        );

                        return DisplayLarge(
                          '${totalPoints ?? '--'}',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
}
