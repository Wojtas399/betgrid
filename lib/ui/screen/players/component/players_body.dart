import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/players_cubit.dart';
import '../cubit/players_state.dart';
import 'players_no_players_info.dart';
import 'players_player_item.dart';

class PlayersBody extends StatelessWidget {
  const PlayersBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isCubitLoading = context.select(
      (PlayersCubit cubit) => cubit.state.isLoading,
    );
    final List<PlayerWithPoints>? playersWithTheirPoints = context.select(
      (PlayersCubit cubit) => cubit.state.playersWithTheirPoints,
    );

    return isCubitLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : playersWithTheirPoints?.isNotEmpty == true
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                padding: const EdgeInsets.all(24),
                itemCount: playersWithTheirPoints!.length,
                itemBuilder: (_, int playerIndex) => PlayersPlayerItem(
                  playerWithPoints: playersWithTheirPoints[playerIndex],
                ),
              )
            : const PlayersNoPlayersInfo();
  }
}
