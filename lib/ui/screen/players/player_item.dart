import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/player.dart';
import '../../component/avatar_component.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text_component.dart';
import '../../config/router/app_router.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/player_points_provider.dart';

class PlayerItem extends StatelessWidget {
  final Player player;

  const PlayerItem({super.key, required this.player});

  void _onTap(BuildContext context) {
    context.navigateTo(
      PlayerProfileRoute(player: player),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.primary,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => _onTap(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Avatar(player: player),
            const GapVertical8(),
            TitleMedium(
              player.username,
              color: Theme.of(context).canvasColor,
              fontWeight: FontWeight.bold,
            ),
            _Points(playerId: player.id),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final Player player;

  const _Avatar({required this.player});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: player.id,
      child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
        final double avatarSize = constraints.maxWidth * 0.5;
        return SizedBox(
          width: avatarSize,
          height: avatarSize,
          child: Avatar(
            avatarUrl: player.avatarUrl,
            username: player.username,
          ),
        );
      }),
    );
  }
}

class _Points extends ConsumerWidget {
  final String playerId;

  const _Points({required this.playerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerPointsAsyncVal = ref.watch(
      playerPointsProvider(playerId: playerId),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BodyMedium(
          '${context.str.points}:',
          color: context.colorScheme.outlineVariant,
        ),
        if (playerPointsAsyncVal.isLoading) ...[
          const GapHorizontal8(),
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              color: context.colorScheme.primaryContainer,
              strokeWidth: 1.6,
            ),
          ),
        ],
        if (!playerPointsAsyncVal.isLoading) ...[
          const GapHorizontal4(),
          BodyMedium(
            '${playerPointsAsyncVal.value}',
            color: context.colorScheme.outlineVariant,
          ),
        ],
      ],
    );
  }
}
