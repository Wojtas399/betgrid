class SeasonGrandPrixBetDto {
  final String id;
  final String userId;
  final int season;
  final String seasonGrandPrixId;
  final List<String?> qualiStandingsBySeasonDriverIds;
  final String? p1SeasonDriverId;
  final String? p2SeasonDriverId;
  final String? p3SeasonDriverId;
  final String? p10SeasonDriverId;
  final String? fastestLapSeasonDriverId;
  final List<String> dnfSeasonDriverIds;
  final bool? willBeSafetyCar;
  final bool? willBeRedFlag;

  const SeasonGrandPrixBetDto({
    this.id = '',
    this.userId = '',
    this.season = 0,
    required this.seasonGrandPrixId,
    required this.qualiStandingsBySeasonDriverIds,
    this.p1SeasonDriverId,
    this.p2SeasonDriverId,
    this.p3SeasonDriverId,
    this.p10SeasonDriverId,
    this.fastestLapSeasonDriverId,
    required this.dnfSeasonDriverIds,
    this.willBeSafetyCar,
    this.willBeRedFlag,
  });

  factory SeasonGrandPrixBetDto.fromFirestore({
    required String id,
    required int season,
    required String userId,
    required Map<String, dynamic> json,
  }) {
    return SeasonGrandPrixBetDto(
      id: id,
      userId: userId,
      season: season,
      seasonGrandPrixId: json[SeasonGrandPrixBetFields.seasonGrandPrixId],
      qualiStandingsBySeasonDriverIds:
          (json[SeasonGrandPrixBetFields.qualiStandingsBySeasonDriverIds]
                  as List)
              .cast<String?>(),
      p1SeasonDriverId: json[SeasonGrandPrixBetFields.p1SeasonDriverId],
      p2SeasonDriverId: json[SeasonGrandPrixBetFields.p2SeasonDriverId],
      p3SeasonDriverId: json[SeasonGrandPrixBetFields.p3SeasonDriverId],
      p10SeasonDriverId: json[SeasonGrandPrixBetFields.p10SeasonDriverId],
      fastestLapSeasonDriverId:
          json[SeasonGrandPrixBetFields.fastestLapSeasonDriverId],
      dnfSeasonDriverIds:
          (json[SeasonGrandPrixBetFields.dnfSeasonDriverIds] as List)
              .cast<String>(),
      willBeSafetyCar: json[SeasonGrandPrixBetFields.willBeSafetyCar],
      willBeRedFlag: json[SeasonGrandPrixBetFields.willBeRedFlag],
    );
  }

  Map<String, dynamic> toFirestore() => {
        SeasonGrandPrixBetFields.seasonGrandPrixId: seasonGrandPrixId,
        SeasonGrandPrixBetFields.qualiStandingsBySeasonDriverIds:
            qualiStandingsBySeasonDriverIds,
        SeasonGrandPrixBetFields.p1SeasonDriverId: p1SeasonDriverId,
        SeasonGrandPrixBetFields.p2SeasonDriverId: p2SeasonDriverId,
        SeasonGrandPrixBetFields.p3SeasonDriverId: p3SeasonDriverId,
        SeasonGrandPrixBetFields.p10SeasonDriverId: p10SeasonDriverId,
        SeasonGrandPrixBetFields.fastestLapSeasonDriverId:
            fastestLapSeasonDriverId,
        SeasonGrandPrixBetFields.dnfSeasonDriverIds: dnfSeasonDriverIds,
        SeasonGrandPrixBetFields.willBeSafetyCar: willBeSafetyCar,
        SeasonGrandPrixBetFields.willBeRedFlag: willBeRedFlag,
      };
}

class SeasonGrandPrixBetFields {
  static const seasonGrandPrixId = 'seasonGrandPrixId';
  static const qualiStandingsBySeasonDriverIds =
      'qualiStandingsBySeasonDriverIds';
  static const p1SeasonDriverId = 'p1SeasonDriverId';
  static const p2SeasonDriverId = 'p2SeasonDriverId';
  static const p3SeasonDriverId = 'p3SeasonDriverId';
  static const p10SeasonDriverId = 'p10SeasonDriverId';
  static const fastestLapSeasonDriverId = 'fastestLapSeasonDriverId';
  static const dnfSeasonDriverIds = 'dnfSeasonDriverIds';
  static const willBeSafetyCar = 'willBeSafetyCar';
  static const willBeRedFlag = 'willBeRedFlag';
}
