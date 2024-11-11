import 'package:equatable/equatable.dart';

import 'entity.dart';

class GrandPrixResults extends Entity {
  final String seasonGrandPrixId;
  final List<String?>? qualiStandingsBySeasonDriverIds;
  final RaceResults? raceResults;

  const GrandPrixResults({
    required super.id,
    required this.seasonGrandPrixId,
    this.qualiStandingsBySeasonDriverIds,
    this.raceResults,
  });

  @override
  List<Object?> get props => [
        id,
        seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds,
        raceResults,
      ];
}

class RaceResults extends Equatable {
  final String p1SeasonDriverId;
  final String p2SeasonDriverId;
  final String p3SeasonDriverId;
  final String p10SeasonDriverId;
  final String fastestLapSeasonDriverId;
  final List<String> dnfSeasonDriverIds;
  final bool wasThereSafetyCar;
  final bool wasThereRedFlag;

  const RaceResults({
    required this.p1SeasonDriverId,
    required this.p2SeasonDriverId,
    required this.p3SeasonDriverId,
    required this.p10SeasonDriverId,
    required this.fastestLapSeasonDriverId,
    required this.dnfSeasonDriverIds,
    required this.wasThereSafetyCar,
    required this.wasThereRedFlag,
  });

  @override
  List<Object?> get props => [
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
