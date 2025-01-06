import 'package:betgrid/model/user_stats.dart';

class PlayerStatsCreator {
  final String id;
  final String userId;
  final int season;
  late final UserStatsPointsForGp bestGpPoints;
  late final UserStatsPointsForGp bestQualiPoints;
  late final UserStatsPointsForGp bestRacePoints;
  final List<UserStatsPointsForDriver> pointsForDrivers;

  PlayerStatsCreator({
    this.id = '',
    this.userId = '',
    this.season = 0,
    UserStatsPointsForGp? bestGpPoints,
    UserStatsPointsForGp? bestQualiPoints,
    UserStatsPointsForGp? bestRacePoints,
    this.pointsForDrivers = const [],
  }) {
    this.bestGpPoints =
        bestGpPoints ?? const PlayerStatsPointsForGpCreator().create();
    this.bestQualiPoints =
        bestQualiPoints ?? const PlayerStatsPointsForGpCreator().create();
    this.bestRacePoints =
        bestRacePoints ?? const PlayerStatsPointsForGpCreator().create();
  }

  UserStats create() {
    return UserStats(
      id: id,
      userId: userId,
      season: season,
      bestGpPoints: bestGpPoints,
      bestQualiPoints: bestQualiPoints,
      bestRacePoints: bestRacePoints,
      pointsForDrivers: pointsForDrivers,
    );
  }
}

class PlayerStatsPointsForGpCreator {
  final String seasonGrandPrixId;
  final double points;

  const PlayerStatsPointsForGpCreator({
    this.seasonGrandPrixId = '',
    this.points = 0,
  });

  UserStatsPointsForGp create() {
    return UserStatsPointsForGp(
      seasonGrandPrixId: seasonGrandPrixId,
      points: points,
    );
  }
}
