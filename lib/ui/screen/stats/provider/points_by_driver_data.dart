import 'package:equatable/equatable.dart';

import '../../../../model/player.dart';

class PointsByDriverPlayerPoints extends Equatable {
  final Player player;
  final double points;

  const PointsByDriverPlayerPoints({
    required this.player,
    required this.points,
  });

  @override
  List<Object?> get props => [player, points];
}
