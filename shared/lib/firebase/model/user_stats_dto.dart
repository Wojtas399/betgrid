import 'user_stats_points_for_driver_dto.dart';
import 'user_stats_points_for_gp_dto.dart';

class UserStatsDto {
  final String userId;
  final int season;
  final double totalPoints;
  final UserStatsPointsForGpDto? bestGpPoints;
  final UserStatsPointsForGpDto? bestQualiPoints;
  final UserStatsPointsForGpDto? bestRacePoints;
  final List<UserStatsPointsForDriverDto>? pointsForDrivers;

  const UserStatsDto({
    this.userId = '',
    this.season = 0,
    required this.totalPoints,
    this.bestGpPoints,
    this.bestQualiPoints,
    this.bestRacePoints,
    this.pointsForDrivers,
  });

  factory UserStatsDto.fromFirestore({
    required String userId,
    required int season,
    required Map<String, dynamic> json,
  }) {
    final bestGpPointsJson = json[UserStatsFields.bestGpPoints];
    final bestQualiPointsJson = json[UserStatsFields.bestQualiPoints];
    final bestRacePointsJson = json[UserStatsFields.bestRacePoints];
    final pointsForDriversJson = json[UserStatsFields.pointsForDrivers];

    return UserStatsDto(
      userId: userId,
      season: season,
      totalPoints: (json[UserStatsFields.totalPoints] as num).toDouble(),
      bestGpPoints: bestGpPointsJson != null
          ? UserStatsPointsForGpDto.fromFirestore(json: bestGpPointsJson)
          : null,
      bestQualiPoints: bestQualiPointsJson != null
          ? UserStatsPointsForGpDto.fromFirestore(json: bestQualiPointsJson)
          : null,
      bestRacePoints: bestRacePointsJson != null
          ? UserStatsPointsForGpDto.fromFirestore(json: bestRacePointsJson)
          : null,
      pointsForDrivers: pointsForDriversJson != null
          ? _mapPointsForDriversFromFirestore(pointsForDriversJson)
          : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
        UserStatsFields.totalPoints: totalPoints,
        UserStatsFields.bestGpPoints: bestGpPoints?.toFirestore(),
        UserStatsFields.bestQualiPoints: bestQualiPoints?.toFirestore(),
        UserStatsFields.bestRacePoints: bestRacePoints?.toFirestore(),
        UserStatsFields.pointsForDrivers: _mapPointsForDriversToFirestore(
          pointsForDrivers,
        ),
      };

  static List<UserStatsPointsForDriverDto> _mapPointsForDriversFromFirestore(
    List<dynamic> jsonsList,
  ) =>
      jsonsList
          .map((e) => UserStatsPointsForDriverDto.fromFirestore(json: e))
          .toList();

  static List<Map<String, dynamic>>? _mapPointsForDriversToFirestore(
    List<UserStatsPointsForDriverDto>? dtos,
  ) =>
      dtos?.map((e) => e.toFirestore()).toList();
}

class UserStatsFields {
  static const totalPoints = 'totalPoints';
  static const bestGpPoints = 'bestGpPoints';
  static const bestQualiPoints = 'bestQualiPoints';
  static const bestRacePoints = 'bestRacePoints';
  static const pointsForDrivers = 'pointsForDrivers';
}
