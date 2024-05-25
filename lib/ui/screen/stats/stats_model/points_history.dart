import 'package:equatable/equatable.dart';

import '../../../../model/player.dart';

class PointsHistory extends Equatable {
  final Iterable<Player> players;
  final Iterable<PointsHistoryGrandPrix> grandPrixes;

  const PointsHistory({
    required this.players,
    required this.grandPrixes,
  });

  @override
  List<Object?> get props => [players, grandPrixes];
}

class PointsHistoryGrandPrix extends Equatable {
  final int roundNumber;
  final List<PointsHistoryPlayerPoints> playersPoints;

  const PointsHistoryGrandPrix({
    required this.roundNumber,
    required this.playersPoints,
  });

  @override
  List<Object?> get props => [roundNumber, playersPoints];
}

class PointsHistoryPlayerPoints extends Equatable {
  final String playerId;
  final double points;

  const PointsHistoryPlayerPoints({
    required this.playerId,
    required this.points,
  });

  @override
  List<Object?> get props => [playerId, points];
}
