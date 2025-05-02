class SeasonDriverDto {
  final String id;
  final int season;
  final String driverId;
  final int driverNumber;
  final String seasonTeamId;

  const SeasonDriverDto({
    this.id = '',
    required this.season,
    required this.driverId,
    required this.driverNumber,
    required this.seasonTeamId,
  });

  factory SeasonDriverDto.fromFirestore({
    required String id,
    required int season,
    required Map<String, dynamic> json,
  }) {
    return SeasonDriverDto(
      id: id,
      season: season,
      driverId: json[SeasonDriverFields.driverId],
      driverNumber: json[SeasonDriverFields.driverNumber],
      seasonTeamId: json[SeasonDriverFields.seasonTeamId],
    );
  }

  Map<String, dynamic> toFirestore() => {
        SeasonDriverFields.driverId: driverId,
        SeasonDriverFields.driverNumber: driverNumber,
        SeasonDriverFields.seasonTeamId: seasonTeamId,
      };
}

class SeasonDriverFields {
  static const driverId = 'driverId';
  static const driverNumber = 'driverNumber';
  static const seasonTeamId = 'seasonTeamId';
}
