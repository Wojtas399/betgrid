import 'package:equatable/equatable.dart';

import 'entity.dart';

class UserStats extends Entity {
  final String userId;
  final int season;
  final UserStatsPointsForGp bestGpPoints;
  final UserStatsPointsForGp bestQualiPoints;
  final UserStatsPointsForGp bestRacePoints;
  final List<UserStatsPointsForDriver> pointsForDrivers;

  const UserStats({
    required super.id,
    required this.userId,
    required this.season,
    required this.bestGpPoints,
    required this.bestQualiPoints,
    required this.bestRacePoints,
    required this.pointsForDrivers,
  });

  UserStatsPointsForDriver get bestDriverPoints {
    final sortedPointsForDrivers = [...pointsForDrivers];
    sortedPointsForDrivers.sort((d1, d2) => d2.points.compareTo(d1.points));
    return sortedPointsForDrivers.first;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        season,
        bestGpPoints,
        bestQualiPoints,
        bestRacePoints,
        pointsForDrivers,
      ];
}

abstract class UserStatsPoints extends Equatable {
  final double points;

  const UserStatsPoints({
    required this.points,
  });
}

class UserStatsPointsForGp extends UserStatsPoints {
  final String seasonGrandPrixId;

  const UserStatsPointsForGp({
    required this.seasonGrandPrixId,
    required super.points,
  });

  @override
  List<Object?> get props => [
        seasonGrandPrixId,
        points,
      ];
}

class UserStatsPointsForDriver extends UserStatsPoints {
  final String seasonDriverId;

  const UserStatsPointsForDriver({
    required this.seasonDriverId,
    required super.points,
  });

  @override
  List<Object?> get props => [
        seasonDriverId,
        points,
      ];
}
