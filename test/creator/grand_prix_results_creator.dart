import 'package:betgrid/data/firebase/model/grand_prix_result_dto/grand_prix_results_dto.dart';
import 'package:betgrid/model/grand_prix_results.dart';

class GrandPrixResultsCreator {
  final String id;
  final String grandPrixId;
  final List<String>? qualiStandingsByDriverIds;
  final String p1DriverId;
  final String p2DriverId;
  final String p3DriverId;
  final String p10DriverId;
  final String fastestLapDriverId;
  final List<String> dnfDriverIds;
  final bool wasThereSafetyCar;
  final bool wasThereRedFlag;

  const GrandPrixResultsCreator({
    this.id = '',
    this.grandPrixId = '',
    this.qualiStandingsByDriverIds,
    this.p1DriverId = '',
    this.p2DriverId = '',
    this.p3DriverId = '',
    this.p10DriverId = '',
    this.fastestLapDriverId = '',
    this.dnfDriverIds = const [],
    this.wasThereSafetyCar = false,
    this.wasThereRedFlag = false,
  });

  GrandPrixResults createEntity() => GrandPrixResults(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        raceResults: RaceResults(
          p1DriverId: p1DriverId,
          p2DriverId: p2DriverId,
          p3DriverId: p3DriverId,
          p10DriverId: p10DriverId,
          fastestLapDriverId: fastestLapDriverId,
          dnfDriverIds: dnfDriverIds,
          wasThereSafetyCar: wasThereSafetyCar,
          wasThereRedFlag: wasThereRedFlag,
        ),
      );

  GrandPrixResultsDto createDto() => GrandPrixResultsDto(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
}
