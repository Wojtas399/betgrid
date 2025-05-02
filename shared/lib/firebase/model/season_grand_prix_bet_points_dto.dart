import 'quali_bet_points_dto.dart';
import 'race_bet_points_dto.dart';

class SeasonGrandPrixBetPointsDto {
  final String id;
  final String userId;
  final int season;
  final String seasonGrandPrixId;
  final double total;
  final QualiBetPointsDto? quali;
  final RaceBetPointsDto? race;

  const SeasonGrandPrixBetPointsDto({
    this.id = '',
    this.userId = '',
    this.season = 0,
    required this.seasonGrandPrixId,
    required this.total,
    this.quali,
    this.race,
  });

  factory SeasonGrandPrixBetPointsDto.fromFirestore({
    required String id,
    required String userId,
    required int season,
    required Map<String, dynamic> json,
  }) {
    return SeasonGrandPrixBetPointsDto(
      id: id,
      userId: userId,
      season: season,
      seasonGrandPrixId: json[SeasonGrandPrixBetPointsFields.seasonGrandPrixId],
      total: (json[SeasonGrandPrixBetPointsFields.total] as num).toDouble(),
      quali: _mapQualiBetPointsFromFirestore(
        json[SeasonGrandPrixBetPointsFields.quali],
      ),
      race: _mapRaceBetPointsFromFirestore(
        json[SeasonGrandPrixBetPointsFields.race],
      ),
    );
  }

  Map<String, Object?> toFirestore() => {
        SeasonGrandPrixBetPointsFields.seasonGrandPrixId: seasonGrandPrixId,
        SeasonGrandPrixBetPointsFields.total: total,
        SeasonGrandPrixBetPointsFields.quali: quali?.toFirestore(),
        SeasonGrandPrixBetPointsFields.race: race?.toFirestore(),
      };

  static QualiBetPointsDto? _mapQualiBetPointsFromFirestore(
    Map<String, dynamic>? json,
  ) =>
      json != null ? QualiBetPointsDto.fromFirestore(json: json) : null;

  static RaceBetPointsDto? _mapRaceBetPointsFromFirestore(
    Map<String, dynamic>? json,
  ) =>
      json != null ? RaceBetPointsDto.fromFirestore(json: json) : null;
}

class SeasonGrandPrixBetPointsFields {
  static const seasonGrandPrixId = 'seasonGrandPrixId';
  static const total = 'total';
  static const quali = 'quali';
  static const race = 'race';
}
