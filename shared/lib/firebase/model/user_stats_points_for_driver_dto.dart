class UserStatsPointsForDriverDto {
  final String seasonDriverId;
  final double points;

  const UserStatsPointsForDriverDto({
    required this.seasonDriverId,
    required this.points,
  });

  factory UserStatsPointsForDriverDto.fromFirestore({
    required Map<String, dynamic> json,
  }) =>
      UserStatsPointsForDriverDto(
        seasonDriverId: json[UserStatsPointsForDriverFields.seasonDriverId],
        points: json[UserStatsPointsForDriverFields.points],
      );

  Map<String, dynamic> toFirestore() => {
        UserStatsPointsForDriverFields.seasonDriverId: seasonDriverId,
        UserStatsPointsForDriverFields.points: points,
      };
}

class UserStatsPointsForDriverFields {
  static const seasonDriverId = 'seasonDriverId';
  static const points = 'points';
}
