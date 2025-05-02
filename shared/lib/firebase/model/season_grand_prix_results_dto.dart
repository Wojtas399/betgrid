class SeasonGrandPrixResultsDto {
  final String id;
  final int season;
  final String seasonGrandPrixId;
  final List<String?>? qualiStandingsBySeasonDriverIds;
  final String? p1SeasonDriverId;
  final String? p2SeasonDriverId;
  final String? p3SeasonDriverId;
  final String? p10SeasonDriverId;
  final String? fastestLapSeasonDriverId;
  final List<String>? dnfSeasonDriverIds;
  final bool? wasThereSafetyCar;
  final bool? wasThereRedFlag;

  const SeasonGrandPrixResultsDto({
    this.id = '',
    required this.season,
    required this.seasonGrandPrixId,
    this.qualiStandingsBySeasonDriverIds,
    this.p1SeasonDriverId,
    this.p2SeasonDriverId,
    this.p3SeasonDriverId,
    this.p10SeasonDriverId,
    this.fastestLapSeasonDriverId,
    this.dnfSeasonDriverIds,
    this.wasThereSafetyCar,
    this.wasThereRedFlag,
  });

  factory SeasonGrandPrixResultsDto.fromFirestore({
    required String id,
    required int season,
    required Map<String, dynamic> json,
  }) {
    return SeasonGrandPrixResultsDto(
      id: id,
      season: season,
      seasonGrandPrixId: json[SeasonGrandPrixResultsFields.seasonGrandPrixId],
      qualiStandingsBySeasonDriverIds:
          (json[SeasonGrandPrixResultsFields.qualiStandingsBySeasonDriverIds]
                  as List)
              .cast<String>(),
      p1SeasonDriverId: json[SeasonGrandPrixResultsFields.p1SeasonDriverId],
      p2SeasonDriverId: json[SeasonGrandPrixResultsFields.p2SeasonDriverId],
      p3SeasonDriverId: json[SeasonGrandPrixResultsFields.p3SeasonDriverId],
      p10SeasonDriverId: json[SeasonGrandPrixResultsFields.p10SeasonDriverId],
      fastestLapSeasonDriverId:
          json[SeasonGrandPrixResultsFields.fastestLapSeasonDriverId],
      dnfSeasonDriverIds:
          (json[SeasonGrandPrixResultsFields.dnfSeasonDriverIds] as List)
              .cast<String>(),
      wasThereSafetyCar: json[SeasonGrandPrixResultsFields.wasThereSafetyCar],
      wasThereRedFlag: json[SeasonGrandPrixResultsFields.wasThereRedFlag],
    );
  }

  Map<String, dynamic> toFirestore() => {
        SeasonGrandPrixResultsFields.seasonGrandPrixId: seasonGrandPrixId,
        SeasonGrandPrixResultsFields.qualiStandingsBySeasonDriverIds:
            qualiStandingsBySeasonDriverIds,
        SeasonGrandPrixResultsFields.p1SeasonDriverId: p1SeasonDriverId,
        SeasonGrandPrixResultsFields.p2SeasonDriverId: p2SeasonDriverId,
        SeasonGrandPrixResultsFields.p3SeasonDriverId: p3SeasonDriverId,
        SeasonGrandPrixResultsFields.p10SeasonDriverId: p10SeasonDriverId,
        SeasonGrandPrixResultsFields.fastestLapSeasonDriverId:
            fastestLapSeasonDriverId,
        SeasonGrandPrixResultsFields.dnfSeasonDriverIds: dnfSeasonDriverIds,
        SeasonGrandPrixResultsFields.wasThereSafetyCar: wasThereSafetyCar,
        SeasonGrandPrixResultsFields.wasThereRedFlag: wasThereRedFlag,
      };
}

class SeasonGrandPrixResultsFields {
  static const seasonGrandPrixId = 'seasonGrandPrixId';
  static const qualiStandingsBySeasonDriverIds =
      'qualiStandingsBySeasonDriverIds';
  static const p1SeasonDriverId = 'p1SeasonDriverId';
  static const p2SeasonDriverId = 'p2SeasonDriverId';
  static const p3SeasonDriverId = 'p3SeasonDriverId';
  static const p10SeasonDriverId = 'p10SeasonDriverId';
  static const fastestLapSeasonDriverId = 'fastestLapSeasonDriverId';
  static const dnfSeasonDriverIds = 'dnfSeasonDriverIds';
  static const wasThereSafetyCar = 'wasThereSafetyCar';
  static const wasThereRedFlag = 'wasThereRedFlag';
}
