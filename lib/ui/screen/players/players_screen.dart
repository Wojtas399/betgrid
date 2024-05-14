import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'cubit/players_cubit.dart';
import 'cubit/players_state.dart';
import 'player_item.dart';

@RoutePage()
class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<PlayersCubit>()..initialize(),
        child: const _Content(),
      );
}

class _Content extends StatelessWidget {
  const _Content();

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
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            padding: const EdgeInsets.all(24),
            itemCount: playersWithTheirPoints!.length,
            itemBuilder: (_, int playerIndex) => PlayerItem(
              playerWithPoints: playersWithTheirPoints[playerIndex],
            ),
          );
  }
}
