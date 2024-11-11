import 'package:injectable/injectable.dart';

import '../../model/grand_prix_results.dart';
import '../firebase/model/grand_prix_results_dto.dart';

@injectable
class GrandPrixResultsMapper {
  GrandPrixResults mapFromDto(
    GrandPrixResultsDto grandPrixResultsDto,
  ) {
    RaceResults? raceResults;
    if (_areThereAllRaceResults(grandPrixResultsDto)) {
      raceResults = RaceResults(
        p1SeasonDriverId: grandPrixResultsDto.p1SeasonDriverId!,
        p2SeasonDriverId: grandPrixResultsDto.p2SeasonDriverId!,
        p3SeasonDriverId: grandPrixResultsDto.p3SeasonDriverId!,
        p10SeasonDriverId: grandPrixResultsDto.p10SeasonDriverId!,
        fastestLapSeasonDriverId: grandPrixResultsDto.fastestLapSeasonDriverId!,
        dnfSeasonDriverIds: grandPrixResultsDto.dnfSeasonDriverIds!,
        wasThereSafetyCar: grandPrixResultsDto.wasThereSafetyCar!,
        wasThereRedFlag: grandPrixResultsDto.wasThereRedFlag!,
      );
    }
    return GrandPrixResults(
      id: grandPrixResultsDto.id,
      seasonGrandPrixId: grandPrixResultsDto.seasonGrandPrixId,
      qualiStandingsBySeasonDriverIds:
          grandPrixResultsDto.qualiStandingsBySeasonDriverIds,
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
