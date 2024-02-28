import 'package:betgrid/data/mapper/grand_prix_results_mapper.dart';
import 'package:betgrid/firebase/model/grand_prix_result_dto/grand_prix_results_dto.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'gpb1';
  const String grandPrixId = 'gp1';
  final List<String> qualiStandingsByDriverIds = List.generate(
    20,
    (index) => 'd$index',
  );
  const String p1DriverId = 'd1';
  const String p2DriverId = 'd2';
  const String p3DriverId = 'd3';
  const String p10DriverId = 'd4';
  const String fastestLapDriverId = 'd1';
  const List<String> dnfDriverIds = ['d10', 'd11', 'd12'];
  const bool wasThereSafetyCar = true;
  const bool wasThereRedFlag = false;

  test(
    'mapGrandPrixResultsFromDto, '
    'should map GrandPrixResultsDto model to GrandPrixResults model',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
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
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
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

      final GrandPrixResults grandPrixResults = mapGrandPrixResultsFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );
}
