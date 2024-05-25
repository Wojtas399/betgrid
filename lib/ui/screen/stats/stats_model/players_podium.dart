import 'package:equatable/equatable.dart';

import '../../../../model/player.dart';

class PlayersPodium extends Equatable {
  final PlayersPodiumPlayer p1Player;
  final PlayersPodiumPlayer? p2Player;
  final PlayersPodiumPlayer? p3Player;

  const PlayersPodium({
    required this.p1Player,
    this.p2Player,
    this.p3Player,
  });

  @override
  List<Object?> get props => [p1Player, p2Player, p3Player];
}

class PlayersPodiumPlayer extends Equatable {
  final Player player;
  final double points;

  const PlayersPodiumPlayer({
    required this.player,
    required this.points,
  });

  @override
  List<Object?> get props => [player, points];
}
