import 'package:betgrid/data/firebase/model/grand_prix_results_dto.dart';
import 'package:betgrid/model/grand_prix_results.dart';

class GrandPrixResultsCreator {
  final String id;
  final String seasonGrandPrixId;
  final List<String>? qualiStandingsBySeasonDriverIds;
  final String p1SeasonDriverId;
  final String p2SeasonDriverId;
  final String p3SeasonDriverId;
  final String p10SeasonDriverId;
  final String fastestLapSeasonDriverId;
  final List<String> dnfSeasonDriverIds;
  final bool wasThereSafetyCar;
  final bool wasThereRedFlag;

  const GrandPrixResultsCreator({
    this.id = '',
    this.seasonGrandPrixId = '',
    this.qualiStandingsBySeasonDriverIds,
    this.p1SeasonDriverId = '',
    this.p2SeasonDriverId = '',
    this.p3SeasonDriverId = '',
    this.p10SeasonDriverId = '',
    this.fastestLapSeasonDriverId = '',
    this.dnfSeasonDriverIds = const [],
    this.wasThereSafetyCar = false,
    this.wasThereRedFlag = false,
  });

  GrandPrixResults createEntity() {
    return GrandPrixResults(
      id: id,
      seasonGrandPrixId: seasonGrandPrixId,
      qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
      raceResults: RaceResults(
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      ),
    );
  }

  GrandPrixResultsDto createDto() {
    return GrandPrixResultsDto(
      id: id,
      seasonGrandPrixId: seasonGrandPrixId,
      qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
      p1SeasonDriverId: p1SeasonDriverId,
      p2SeasonDriverId: p2SeasonDriverId,
      p3SeasonDriverId: p3SeasonDriverId,
      p10SeasonDriverId: p10SeasonDriverId,
      fastestLapSeasonDriverId: fastestLapSeasonDriverId,
      dnfSeasonDriverIds: dnfSeasonDriverIds,
      wasThereSafetyCar: wasThereSafetyCar,
      wasThereRedFlag: wasThereRedFlag,
    );
  }

  Map<String, Object?> createJson() {
    return {
      'seasonGrandPrixId': seasonGrandPrixId,
      'qualiStandingsBySeasonDriverIds': qualiStandingsBySeasonDriverIds,
      'p1SeasonDriverId': p1SeasonDriverId,
      'p2SeasonDriverId': p2SeasonDriverId,
      'p3SeasonDriverId': p3SeasonDriverId,
      'p10SeasonDriverId': p10SeasonDriverId,
      'fastestLapSeasonDriverId': fastestLapSeasonDriverId,
      'dnfSeasonDriverIds': dnfSeasonDriverIds,
      'wasThereSafetyCar': wasThereSafetyCar,
      'wasThereRedFlag': wasThereRedFlag,
    };
  }
}
