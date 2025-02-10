import 'package:betgrid/model/season_grand_prix_results.dart';

class SeasonGrandPrixResultsCreator {
  final String id;
  final int season;
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

  const SeasonGrandPrixResultsCreator({
    this.id = '',
    this.season = 2024,
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

  SeasonGrandPrixResults create() {
    return SeasonGrandPrixResults(
      id: id,
      season: season,
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
}
