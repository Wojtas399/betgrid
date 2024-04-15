import '../../firebase/model/grand_prix_result_dto/grand_prix_results_dto.dart';
import '../../model/grand_prix_results.dart';

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
      p1DriverId: grandPrixResultsDto.p1DriverId!,
      p2DriverId: grandPrixResultsDto.p2DriverId!,
      p3DriverId: grandPrixResultsDto.p3DriverId!,
      p10DriverId: grandPrixResultsDto.p10DriverId!,
      fastestLapDriverId: grandPrixResultsDto.fastestLapDriverId!,
      dnfDriverIds: grandPrixResultsDto.dnfDriverIds!,
      wasThereSafetyCar: grandPrixResultsDto.wasThereSafetyCar!,
      wasThereRedFlag: grandPrixResultsDto.wasThereRedFlag!,
    );
  }
  return GrandPrixResults(
    id: grandPrixResultsDto.id,
    grandPrixId: grandPrixResultsDto.grandPrixId,
    qualiStandingsByDriverIds: grandPrixResultsDto.qualiStandingsByDriverIds,
    raceResults: raceResults,
  );
}
