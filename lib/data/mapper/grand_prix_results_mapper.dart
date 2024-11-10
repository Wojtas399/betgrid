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
        p1SeasonDriverId: grandPrixResultsDto.p1DriverId!,
        p2SeasonDriverId: grandPrixResultsDto.p2DriverId!,
        p3SeasonDriverId: grandPrixResultsDto.p3DriverId!,
        p10SeasonDriverId: grandPrixResultsDto.p10DriverId!,
        fastestLapSeasonDriverId: grandPrixResultsDto.fastestLapDriverId!,
        dnfSeasonDriverIds: grandPrixResultsDto.dnfDriverIds!,
        wasThereSafetyCar: grandPrixResultsDto.wasThereSafetyCar!,
        wasThereRedFlag: grandPrixResultsDto.wasThereRedFlag!,
      );
    }
    return GrandPrixResults(
      id: grandPrixResultsDto.id,
      grandPrixId: grandPrixResultsDto.grandPrixId,
      qualiStandingsBySeasonDriverIds:
          grandPrixResultsDto.qualiStandingsByDriverIds,
      raceResults: raceResults,
    );
  }

  bool _areThereAllRaceResults(GrandPrixResultsDto grandPrixResultsDto) =>
      grandPrixResultsDto.p1DriverId != null &&
      grandPrixResultsDto.p2DriverId != null &&
      grandPrixResultsDto.p3DriverId != null &&
      grandPrixResultsDto.p10DriverId != null &&
      grandPrixResultsDto.fastestLapDriverId != null &&
      grandPrixResultsDto.dnfDriverIds != null &&
      grandPrixResultsDto.wasThereSafetyCar != null &&
      grandPrixResultsDto.wasThereRedFlag != null;
}

GrandPrixResults mapGrandPrixResultsFromDto(
  GrandPrixResultsDto grandPrixResultsDto,
) {
  RaceResults? raceResults;
  if (grandPrixResultsDto.p1DriverId != null &&
      grandPrixResultsDto.p2DriverId != null &&
      grandPrixResultsDto.p3DriverId != null &&
      grandPrixResultsDto.p10DriverId != null &&
      grandPrixResultsDto.fastestLapDriverId != null &&
      grandPrixResultsDto.dnfDriverIds != null &&
      grandPrixResultsDto.wasThereSafetyCar != null &&
      grandPrixResultsDto.wasThereRedFlag != null) {
    raceResults = RaceResults(
      p1SeasonDriverId: grandPrixResultsDto.p1DriverId!,
      p2SeasonDriverId: grandPrixResultsDto.p2DriverId!,
      p3SeasonDriverId: grandPrixResultsDto.p3DriverId!,
      p10SeasonDriverId: grandPrixResultsDto.p10DriverId!,
      fastestLapSeasonDriverId: grandPrixResultsDto.fastestLapDriverId!,
      dnfSeasonDriverIds: grandPrixResultsDto.dnfDriverIds!,
      wasThereSafetyCar: grandPrixResultsDto.wasThereSafetyCar!,
      wasThereRedFlag: grandPrixResultsDto.wasThereRedFlag!,
    );
  }
  return GrandPrixResults(
    id: grandPrixResultsDto.id,
    grandPrixId: grandPrixResultsDto.grandPrixId,
    qualiStandingsBySeasonDriverIds:
        grandPrixResultsDto.qualiStandingsByDriverIds,
    raceResults: raceResults,
  );
}
