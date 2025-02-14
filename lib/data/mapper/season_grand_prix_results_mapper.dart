import 'package:betgrid_shared/firebase/model/season_grand_prix_results_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/season_grand_prix_results.dart';

@injectable
class SeasonGrandPrixResultsMapper {
  SeasonGrandPrixResults mapFromDto(SeasonGrandPrixResultsDto resultsDto) {
    RaceResults? raceResults;
    if (_areThereAllRaceResults(resultsDto)) {
      raceResults = RaceResults(
        p1SeasonDriverId: resultsDto.p1SeasonDriverId!,
        p2SeasonDriverId: resultsDto.p2SeasonDriverId!,
        p3SeasonDriverId: resultsDto.p3SeasonDriverId!,
        p10SeasonDriverId: resultsDto.p10SeasonDriverId!,
        fastestLapSeasonDriverId: resultsDto.fastestLapSeasonDriverId!,
        dnfSeasonDriverIds: resultsDto.dnfSeasonDriverIds!,
        wasThereSafetyCar: resultsDto.wasThereSafetyCar!,
        wasThereRedFlag: resultsDto.wasThereRedFlag!,
      );
    }
    return SeasonGrandPrixResults(
      id: resultsDto.id,
      season: resultsDto.season,
      seasonGrandPrixId: resultsDto.seasonGrandPrixId,
      qualiStandingsBySeasonDriverIds:
          resultsDto.qualiStandingsBySeasonDriverIds,
      raceResults: raceResults,
    );
  }

  bool _areThereAllRaceResults(SeasonGrandPrixResultsDto resultsDto) =>
      resultsDto.p1SeasonDriverId != null &&
      resultsDto.p2SeasonDriverId != null &&
      resultsDto.p3SeasonDriverId != null &&
      resultsDto.p10SeasonDriverId != null &&
      resultsDto.fastestLapSeasonDriverId != null &&
      resultsDto.dnfSeasonDriverIds != null &&
      resultsDto.wasThereSafetyCar != null &&
      resultsDto.wasThereRedFlag != null;
}
