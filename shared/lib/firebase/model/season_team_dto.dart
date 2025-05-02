class SeasonTeamDto {
  final String id;
  final int season;
  final String shortName;
  final String fullName;
  final String teamChief;
  final String technicalChief;
  final String chassis;
  final String powerUnit;
  final String baseHexColor;
  final String logoImgName;
  final String carImgName;

  const SeasonTeamDto({
    this.id = '',
    this.season = 0,
    required this.shortName,
    required this.fullName,
    required this.teamChief,
    required this.technicalChief,
    required this.chassis,
    required this.powerUnit,
    required this.baseHexColor,
    required this.logoImgName,
    required this.carImgName,
  });

  factory SeasonTeamDto.fromFirestore({
    required String id,
    required int season,
    required Map<String, dynamic> json,
  }) {
    return SeasonTeamDto(
      id: id,
      season: season,
      shortName: json[SeasonTeamFields.shortName],
      fullName: json[SeasonTeamFields.fullName],
      teamChief: json[SeasonTeamFields.teamChief],
      technicalChief: json[SeasonTeamFields.technicalChief],
      chassis: json[SeasonTeamFields.chassis],
      powerUnit: json[SeasonTeamFields.powerUnit],
      baseHexColor: json[SeasonTeamFields.baseHexColor],
      logoImgName: json[SeasonTeamFields.logoImgName],
      carImgName: json[SeasonTeamFields.carImgName],
    );
  }

  Map<String, dynamic> toFirestore() => {
        SeasonTeamFields.shortName: shortName,
        SeasonTeamFields.fullName: fullName,
        SeasonTeamFields.teamChief: teamChief,
        SeasonTeamFields.technicalChief: technicalChief,
        SeasonTeamFields.chassis: chassis,
        SeasonTeamFields.powerUnit: powerUnit,
        SeasonTeamFields.baseHexColor: baseHexColor,
        SeasonTeamFields.logoImgName: logoImgName,
        SeasonTeamFields.carImgName: carImgName,
      };
}

class SeasonTeamFields {
  static const String shortName = 'shortName';
  static const String fullName = 'fullName';
  static const String teamChief = 'teamChief';
  static const String technicalChief = 'technicalChief';
  static const String chassis = 'chassis';
  static const String powerUnit = 'powerUnit';
  static const String baseHexColor = 'baseHexColor';
  static const String logoImgName = 'logoImgName';
  static const String carImgName = 'carImgName';
}
