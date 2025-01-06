import 'package:equatable/equatable.dart';

import 'entity.dart';

class PlayerStats extends Entity {
  final String playerId;
  final int season;
  final PlayerStatsPointsForGp bestGpPoints;
  final PlayerStatsPointsForGp bestQualiPoints;
  final PlayerStatsPointsForGp bestRacePoints;
  final List<PlayerStatsPointsForDriver> pointsForDrivers;

  const PlayerStats({
    required super.id,
    required this.playerId,
    required this.season,
    required this.bestGpPoints,
    required this.bestQualiPoints,
    required this.bestRacePoints,
    required this.pointsForDrivers,
  });

  PlayerStatsPointsForDriver get bestDriverPoints {
    final sortedPointsForDrivers = [...pointsForDrivers];
    sortedPointsForDrivers.sort((d1, d2) => d2.points.compareTo(d1.points));
    return sortedPointsForDrivers.first;
  }

  @override
  List<Object?> get props => [
        id,
        playerId,
        season,
        bestGpPoints,
        bestQualiPoints,
        bestRacePoints,
        pointsForDrivers,
      ];
}

abstract class PlayerStatsPoints extends Equatable {
  final double points;

  const PlayerStatsPoints({
    required this.points,
  });
}

class PlayerStatsPointsForGp extends PlayerStatsPoints {
  final String seasonGrandPrixId;

  const PlayerStatsPointsForGp({
    required this.seasonGrandPrixId,
    required super.points,
  });

  @override
  List<Object?> get props => [
        seasonGrandPrixId,
        points,
      ];
}

class PlayerStatsPointsForDriver extends PlayerStatsPoints {
  final String seasonDriverId;

  const PlayerStatsPointsForDriver({
    required this.seasonDriverId,
    required super.points,
  });

  @override
  List<Object?> get props => [
        seasonDriverId,
        points,
      ];
}
