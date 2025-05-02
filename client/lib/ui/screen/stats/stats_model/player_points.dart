import 'package:equatable/equatable.dart';

import '../../../../model/player.dart';

class PlayerPoints extends Equatable {
  final Player player;
  final double points;

  const PlayerPoints({required this.player, required this.points});

  @override
  List<Object?> get props => [player, points];
}
