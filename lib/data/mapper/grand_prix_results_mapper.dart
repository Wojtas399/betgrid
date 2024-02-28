import '../../firebase/model/grand_prix_result_dto/grand_prix_results_dto.dart';
import '../../model/grand_prix_results.dart';

GrandPrixResults mapGrandPrixResultsFromDto(
  GrandPrixResultsDto grandPrixResultsDto,
) =>
    GrandPrixResults(
      id: grandPrixResultsDto.id,
      grandPrixId: grandPrixResultsDto.grandPrixId,
      qualiStandingsByDriverIds: grandPrixResultsDto.qualiStandingsByDriverIds,
      p1DriverId: grandPrixResultsDto.p1DriverId,
      p2DriverId: grandPrixResultsDto.p2DriverId,
      p3DriverId: grandPrixResultsDto.p3DriverId,
      p10DriverId: grandPrixResultsDto.p10DriverId,
      fastestLapDriverId: grandPrixResultsDto.fastestLapDriverId,
      dnfDriverIds: grandPrixResultsDto.dnfDriverIds,
      wasThereSafetyCar: grandPrixResultsDto.wasThereSafetyCar,
      wasThereRedFlag: grandPrixResultsDto.wasThereRedFlag,
    );
