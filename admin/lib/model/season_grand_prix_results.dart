import 'entity.dart';

class SeasonGrandPrixResults extends Entity {
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

  const SeasonGrandPrixResults({
    required super.id,
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

  @override
  List<Object?> get props => [
    id,
    season,
    seasonGrandPrixId,
    qualiStandingsBySeasonDriverIds,
    p1SeasonDriverId,
    p2SeasonDriverId,
    p3SeasonDriverId,
    p10SeasonDriverId,
    fastestLapSeasonDriverId,
    dnfSeasonDriverIds,
    wasThereSafetyCar,
    wasThereRedFlag,
  ];
}
