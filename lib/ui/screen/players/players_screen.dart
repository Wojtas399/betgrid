import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/player.dart';
import '../../component/avatar_component.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import '../../config/router/app_router.dart';
import '../../provider/all_players_provider.dart';

@RoutePage()
class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlayersList();
  }
}

class _PlayersList extends ConsumerWidget {
  const _PlayersList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Player>?> players = ref.watch(allPlayersProvider);

    if (players.hasValue) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        padding: const EdgeInsets.all(24),
        itemCount: players.value!.length,
        itemBuilder: (_, int playerIndex) {
          return _PlayerItem(player: players.value![playerIndex]);
        },
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _PlayerItem extends StatelessWidget {
  final Player player;

  const _PlayerItem({required this.player});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          context.navigateTo(
            PlayerProfileRoute(player: player),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
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
            ),
            const GapVertical8(),
            TitleMedium(
              player.username,
              color: Theme.of(context).canvasColor,
              fontWeight: FontWeight.bold,
            ),
            BodyMedium(
              'Punkty: 0',
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}
