import 'package:betgrid/firebase/model/grand_prix_result_dto/grand_prix_result_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String grandPrixId = 'gp1';
  const List<String> qualiStandingsByDriverIds = ['d1', 'd3', 'd2'];
  const String p1DriverId = 'd1';
  const String p2DriverId = 'd2';
  const String p3DriverId = 'd3';
  const String p10DriverId = 'd4';
  const String fastestLapDriverId = 'd1';
  const List<String> dnfDriverIds = ['d10', 'd11', 'd12'];
  const bool wasThereSafetyCar = true;
  const bool wasThereRedFlag = false;

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      final Map<String, Object?> json = {
        'grandPrixId': grandPrixId,
        'qualiStandingsByDriverIds': qualiStandingsByDriverIds,
        'p1DriverId': p1DriverId,
        'p2DriverId': p2DriverId,
        'p3DriverId': p3DriverId,
        'p10DriverId': p10DriverId,
        'fastestLapDriverId': fastestLapDriverId,
        'dnfDriverIds': dnfDriverIds,
        'wasThereSafetyCar': wasThereSafetyCar,
        'wasThereRedFlag': wasThereRedFlag
      };
      const GrandPrixResultDto expectedModel = GrandPrixResultDto(
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        wasThereRedFlag: wasThereRedFlag,
        wasThereSafetyCar: wasThereSafetyCar,
      );

      final GrandPrixResultDto model = GrandPrixResultDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'fromIdAndJson, '
    'should map json model to class model with given id',
    () {
      const String id = 'd1';
      final Map<String, Object?> json = {
        'id': id,
        'grandPrixId': grandPrixId,
        'qualiStandingsByDriverIds': qualiStandingsByDriverIds,
        'p1DriverId': p1DriverId,
        'p2DriverId': p2DriverId,
        'p3DriverId': p3DriverId,
        'p10DriverId': p10DriverId,
        'fastestLapDriverId': fastestLapDriverId,
        'dnfDriverIds': dnfDriverIds,
        'wasThereSafetyCar': wasThereSafetyCar,
        'wasThereRedFlag': wasThereRedFlag
      };
      const GrandPrixResultDto expectedModel = GrandPrixResultDto(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        wasThereRedFlag: wasThereRedFlag,
        wasThereSafetyCar: wasThereSafetyCar,
      );

      final GrandPrixResultDto model =
          GrandPrixResultDto.fromIdAndJson(id, json);

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model ignoring id',
    () {
      const GrandPrixResultDto model = GrandPrixResultDto(
        id: 'gpb1',
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        wasThereRedFlag: wasThereRedFlag,
        wasThereSafetyCar: wasThereSafetyCar,
      );
      final Map<String, Object?> expectedJson = {
        'grandPrixId': grandPrixId,
        'qualiStandingsByDriverIds': qualiStandingsByDriverIds,
        'p1DriverId': p1DriverId,
        'p2DriverId': p2DriverId,
        'p3DriverId': p3DriverId,
        'p10DriverId': p10DriverId,
        'fastestLapDriverId': fastestLapDriverId,
        'dnfDriverIds': dnfDriverIds,
        'wasThereSafetyCar': wasThereSafetyCar,
        'wasThereRedFlag': wasThereRedFlag
      };

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
