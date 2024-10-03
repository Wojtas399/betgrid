import 'package:betgrid/data/firebase/model/grand_prix_bet_dto/grand_prix_bet_dto.dart';
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
  const bool willBeSafetyCar = true;
  const bool willBeRedFlag = false;

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
        'willBeSafetyCar': willBeSafetyCar,
        'willBeRedFlag': willBeRedFlag
      };
      const GrandPrixBetDto expectedModel = GrandPrixBetDto(
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        willBeRedFlag: willBeRedFlag,
        willBeSafetyCar: willBeSafetyCar,
      );

      final GrandPrixBetDto model = GrandPrixBetDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id and playerId',
    () {
      const String id = 'd1';
      const String playerId = 'p1';
      final Map<String, Object?> json = {
        'grandPrixId': grandPrixId,
        'qualiStandingsByDriverIds': qualiStandingsByDriverIds,
        'p1DriverId': p1DriverId,
        'p2DriverId': p2DriverId,
        'p3DriverId': p3DriverId,
        'p10DriverId': p10DriverId,
        'fastestLapDriverId': fastestLapDriverId,
        'dnfDriverIds': dnfDriverIds,
        'willBeSafetyCar': willBeSafetyCar,
        'willBeRedFlag': willBeRedFlag
      };
      const GrandPrixBetDto expectedModel = GrandPrixBetDto(
        id: id,
        playerId: playerId,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        willBeRedFlag: willBeRedFlag,
        willBeSafetyCar: willBeSafetyCar,
      );

      final GrandPrixBetDto model = GrandPrixBetDto.fromFirebase(
        id: id,
        playerId: playerId,
        json: json,
      );

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model ignoring id and player id',
    () {
      const GrandPrixBetDto model = GrandPrixBetDto(
        id: 'gpb1',
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        willBeRedFlag: willBeRedFlag,
        willBeSafetyCar: willBeSafetyCar,
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
        'willBeSafetyCar': willBeSafetyCar,
        'willBeRedFlag': willBeRedFlag
      };

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
