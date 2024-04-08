import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/player.dart';
import 'player_item.dart';
import 'provider/other_players_provider.dart';

@RoutePage()
class PlayersScreen extends ConsumerWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Player>?> playersAsyncVal =
        ref.watch(otherPlayersProvider);

    return playersAsyncVal.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            padding: const EdgeInsets.all(24),
            itemCount: playersAsyncVal.value!.length,
            itemBuilder: (_, int playerIndex) => PlayerItem(
              player: playersAsyncVal.value![playerIndex],
            ),
          );
  }
}
