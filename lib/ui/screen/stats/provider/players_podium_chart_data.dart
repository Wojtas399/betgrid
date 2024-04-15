import 'package:equatable/equatable.dart';

import '../../../../model/player.dart';

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
