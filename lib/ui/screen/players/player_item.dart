import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../model/player.dart';
import '../../component/avatar_component.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text_component.dart';
import '../../config/router/app_router.dart';
import '../../extensions/build_context_extensions.dart';
import 'cubit/players_state.dart';

class PlayerItem extends StatelessWidget {
  final PlayerWithPoints playerWithPoints;

  const PlayerItem({
    super.key,
    required this.playerWithPoints,
  });

  void _onTap(BuildContext context) {
    context.navigateTo(
      PlayerProfileRoute(playerId: playerWithPoints.player.id),
    );
  }

  @override
  Widget build(BuildContext context) => Card(
        color: context.colorScheme.primary,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => _onTap(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Avatar(player: playerWithPoints.player),
              const GapVertical8(),
              TitleMedium(
                playerWithPoints.player.username,
                color: Theme.of(context).canvasColor,
                fontWeight: FontWeight.bold,
              ),
              _Points(points: playerWithPoints.totalPoints),
            ],
          ),
        ),
      );
}

class _Avatar extends StatelessWidget {
  final Player player;

  const _Avatar({
    required this.player,
  });

  @override
  Widget build(BuildContext context) => Hero(
        tag: player.id,
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            final double avatarSize = constraints.maxWidth * 0.5;
            return SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: Avatar(
                avatarUrl: player.avatarUrl,
                username: player.username,
              ),
            );
          },
        ),
      );
}

class _Points extends StatelessWidget {
  final double points;

  const _Points({
    required this.points,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BodyMedium(
            '${context.str.points}:',
            color: context.colorScheme.outlineVariant,
          ),
          const GapHorizontal4(),
          BodyMedium(
            '$points',
            color: context.colorScheme.outlineVariant,
          ),
        ],
      );
}
