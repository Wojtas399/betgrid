import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/player/player_repository_method_providers.dart';
import '../../../../model/player.dart';
import '../../../provider/player_points_provider.dart';

part 'players_podium_chart_data_provider.g.dart';

@riverpod
Future<PlayersPodiumChartData?> playersPodiumChartData(
  PlayersPodiumChartDataRef ref,
) async {
  final allPlayers = await ref.read(allPlayersProvider.future);
  if (allPlayers == null) return null;
  final List<PlayersPodiumChartPlayer> players = [];
  for (final player in allPlayers) {
    final totalPoints = await ref.watch(
      playerPointsProvider(playerId: player.id).future,
    );
    players.add(
      PlayersPodiumChartPlayer(
        player: player,
        points: totalPoints ?? 0.0,
      ),
    );
  }
  players.sort((p1, p2) => p1.points < p2.points ? 1 : -1);
  return PlayersPodiumChartData(
    p1Player: players.first,
    p2Player: players.length >= 2 ? players[1] : null,
    p3Player: players.length >= 3 ? players[2] : null,
  );
}

class PlayersPodiumChartData extends Equatable {
  final PlayersPodiumChartPlayer p1Player;
  final PlayersPodiumChartPlayer? p2Player;
  final PlayersPodiumChartPlayer? p3Player;

  const PlayersPodiumChartData({
    required this.p1Player,
    this.p2Player,
    this.p3Player,
  });

  @override
  List<Object?> get props => [p1Player, p2Player, p3Player];
}

class PlayersPodiumChartPlayer extends Equatable {
  final Player player;
  final double points;

  const PlayersPodiumChartPlayer({
    required this.player,
    required this.points,
  });

  @override
  List<Object?> get props => [player, points];
}
