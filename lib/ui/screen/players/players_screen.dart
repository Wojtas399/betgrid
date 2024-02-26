import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/player.dart';
import '../../component/gap/gap_horizontal.dart';
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
      return ListView.builder(
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
            PlayerProfileRoute(playerId: player.id),
          );
        },
        child: Row(
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: player.avatarUrl != null
                  ? Image.network(
                      player.avatarUrl!,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: TitleLarge(
                        player.username[0].toUpperCase(),
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
            ),
            const GapHorizontal16(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ],
        ),
      ),
    );
  }
}
