import 'package:betgrid/model/player_stats.dart';

class PlayerStatsCreator {
  final String playerId;
  final int season;
  late final PlayerStatsPointsForGp bestGpPoints;
  late final PlayerStatsPointsForGp bestQualiPoints;
  late final PlayerStatsPointsForGp bestRacePoints;
  final List<PlayerStatsPointsForDriver> pointsForDrivers;

  PlayerStatsCreator({
    this.playerId = '',
    this.season = 0,
    PlayerStatsPointsForGp? bestGpPoints,
    PlayerStatsPointsForGp? bestQualiPoints,
    PlayerStatsPointsForGp? bestRacePoints,
    this.pointsForDrivers = const [],
  }) {
    this.bestGpPoints =
        bestGpPoints ?? const PlayerStatsPointsForGpCreator().create();
    this.bestQualiPoints =
        bestQualiPoints ?? const PlayerStatsPointsForGpCreator().create();
    this.bestRacePoints =
        bestRacePoints ?? const PlayerStatsPointsForGpCreator().create();
  }

  PlayerStats create() {
    return PlayerStats(
      playerId: playerId,
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

  PlayerStatsPointsForGp create() {
    return PlayerStatsPointsForGp(
      seasonGrandPrixId: seasonGrandPrixId,
      points: points,
    );
  }
}
