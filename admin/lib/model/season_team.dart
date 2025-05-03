import 'season_entity.dart';

class SeasonTeam extends SeasonEntity {
  final String shortName;
  final String fullName;
  final String teamChief;
  final String technicalChief;
  final String chassis;
  final String powerUnit;
  final String baseHexColor;
  final String logoImgUrl;
  final String carImgUrl;

  const SeasonTeam({
    required super.id,
    required super.season,
    required this.shortName,
    required this.fullName,
    required this.teamChief,
    required this.technicalChief,
    required this.chassis,
    required this.powerUnit,
    required this.baseHexColor,
    required this.logoImgUrl,
    required this.carImgUrl,
  });

  @override
  List<Object?> get props => [
    id,
    season,
    shortName,
    fullName,
    teamChief,
    technicalChief,
    chassis,
    powerUnit,
    baseHexColor,
    logoImgUrl,
    carImgUrl,
  ];
}
