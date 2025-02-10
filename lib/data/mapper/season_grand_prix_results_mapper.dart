import 'package:injectable/injectable.dart';

import '../../model/season_grand_prix_results.dart';
import '../firebase/model/grand_prix_results_dto.dart';

@injectable
class SeasonGrandPrixResultsMapper {
  SeasonGrandPrixResults mapFromDto(
    GrandPrixResultsDto seasonGrandPrixResultsDto,
  ) {
    RaceResults? raceResults;
    if (_areThereAllRaceResults(seasonGrandPrixResultsDto)) {
      raceResults = RaceResults(
        p1SeasonDriverId: seasonGrandPrixResultsDto.p1SeasonDriverId!,
        p2SeasonDriverId: seasonGrandPrixResultsDto.p2SeasonDriverId!,
        p3SeasonDriverId: seasonGrandPrixResultsDto.p3SeasonDriverId!,
        p10SeasonDriverId: seasonGrandPrixResultsDto.p10SeasonDriverId!,
        fastestLapSeasonDriverId:
            seasonGrandPrixResultsDto.fastestLapSeasonDriverId!,
        dnfSeasonDriverIds: seasonGrandPrixResultsDto.dnfSeasonDriverIds!,
        wasThereSafetyCar: seasonGrandPrixResultsDto.wasThereSafetyCar!,
        wasThereRedFlag: seasonGrandPrixResultsDto.wasThereRedFlag!,
      );
    }
    return SeasonGrandPrixResults(
      id: seasonGrandPrixResultsDto.id,
      season: 2024,
      seasonGrandPrixId: seasonGrandPrixResultsDto.seasonGrandPrixId,
      qualiStandingsBySeasonDriverIds:
          seasonGrandPrixResultsDto.qualiStandingsBySeasonDriverIds,
      raceResults: raceResults,
    );
  }

  bool _areThereAllRaceResults(GrandPrixResultsDto grandPrixResultsDto) =>
      grandPrixResultsDto.p1SeasonDriverId != null &&
      grandPrixResultsDto.p2SeasonDriverId != null &&
      grandPrixResultsDto.p3SeasonDriverId != null &&
      grandPrixResultsDto.p10SeasonDriverId != null &&
      grandPrixResultsDto.fastestLapSeasonDriverId != null &&
      grandPrixResultsDto.dnfSeasonDriverIds != null &&
      grandPrixResultsDto.wasThereSafetyCar != null &&
      grandPrixResultsDto.wasThereRedFlag != null;
}
