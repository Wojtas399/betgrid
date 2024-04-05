import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../model/player.dart';
import '../../component/avatar_component.dart';
import '../../component/sliver_grand_prixes_list_component.dart';
import '../../component/sliver_player_total_points_component.dart';
import '../../component/text_component.dart';

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
          SliverPlayerTotalPoints(playerId: player.id),
          SliverGrandPrixesList(playerId: player.id),
        ],
      ),
    );
  }
}

class _AppBar extends SliverAppBar {
  _AppBar({
    required Player player,
    required BuildContext context,
    super.backgroundColor,
    super.foregroundColor,
  }) : super(
          pinned: true,
          expandedHeight: 300,
          surfaceTintColor: Colors.transparent,
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
