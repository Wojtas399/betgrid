class UserStatsPointsForGpDto {
  final String seasonGrandPrixId;
  final double points;

  const UserStatsPointsForGpDto({
    required this.seasonGrandPrixId,
    required this.points,
  });

  factory UserStatsPointsForGpDto.fromFirestore({
    required Map<String, dynamic> json,
  }) =>
      UserStatsPointsForGpDto(
        seasonGrandPrixId: json[UserStatsPointsForGpFields.seasonGrandPrixId],
        points: json[UserStatsPointsForGpFields.points],
      );

  Map<String, dynamic> toFirestore() => {
        UserStatsPointsForGpFields.seasonGrandPrixId: seasonGrandPrixId,
        UserStatsPointsForGpFields.points: points,
      };
}

class UserStatsPointsForGpFields {
  static const seasonGrandPrixId = 'seasonGrandPrixId';
  static const points = 'points';
}
