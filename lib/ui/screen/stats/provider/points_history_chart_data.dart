import 'package:equatable/equatable.dart';

import '../../../../model/player.dart';

class PointsHistoryChartData extends Equatable {
  final List<Player> players;
  final List<PointsHistoryChartGrandPrix> chartGrandPrixes;

  const PointsHistoryChartData({
    required this.players,
    required this.chartGrandPrixes,
  });

  @override
  List<Object?> get props => [players, chartGrandPrixes];
}

class PointsHistoryChartGrandPrix extends Equatable {
  final String grandPrixName;
  final List<PointsHistoryChartPlayerPoints> playersPoints;

  const PointsHistoryChartGrandPrix({
    required this.grandPrixName,
    required this.playersPoints,
  });

  @override
  List<Object?> get props => [grandPrixName, playersPoints];
}

class PointsHistoryChartPlayerPoints extends Equatable {
  final String playerId;
  final double points;

  const PointsHistoryChartPlayerPoints({
    required this.playerId,
    required this.points,
  });

  @override
  List<Object?> get props => [playerId, points];
}
