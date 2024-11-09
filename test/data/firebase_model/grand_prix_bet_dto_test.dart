import 'package:betgrid/data/firebase/model/grand_prix_bet_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String grandPrixId = 'gp1';
  const List<String> qualiStandingsBySeasonDriverIds = ['d1', 'd3', 'd2'];
  const String p1SeasonDriverId = 'd1';
  const String p2SeasonDriverId = 'd2';
  const String p3SeasonDriverId = 'd3';
  const String p10SeasonDriverId = 'd4';
  const String fastestLapSeasonDriverId = 'd1';
  const List<String> dnfSeasonDriverIds = ['d10', 'd11', 'd12'];
  const bool willBeSafetyCar = true;
  const bool willBeRedFlag = false;

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      final Map<String, Object?> json = {
        'grandPrixId': grandPrixId,
        'qualiStandingsByDriverIds': qualiStandingsBySeasonDriverIds,
        'p1DriverId': p1SeasonDriverId,
        'p2DriverId': p2SeasonDriverId,
        'p3DriverId': p3SeasonDriverId,
        'p10DriverId': p10SeasonDriverId,
        'fastestLapDriverId': fastestLapSeasonDriverId,
        'dnfDriverIds': dnfSeasonDriverIds,
        'willBeSafetyCar': willBeSafetyCar,
        'willBeRedFlag': willBeRedFlag
      };
      const GrandPrixBetDto expectedModel = GrandPrixBetDto(
        grandPrixId: grandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
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
        'qualiStandingsByDriverIds': qualiStandingsBySeasonDriverIds,
        'p1DriverId': p1SeasonDriverId,
        'p2DriverId': p2SeasonDriverId,
        'p3DriverId': p3SeasonDriverId,
        'p10DriverId': p10SeasonDriverId,
        'fastestLapDriverId': fastestLapSeasonDriverId,
        'dnfDriverIds': dnfSeasonDriverIds,
        'willBeSafetyCar': willBeSafetyCar,
        'willBeRedFlag': willBeRedFlag
      };
      const GrandPrixBetDto expectedModel = GrandPrixBetDto(
        id: id,
        playerId: playerId,
        grandPrixId: grandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
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
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        willBeRedFlag: willBeRedFlag,
        willBeSafetyCar: willBeSafetyCar,
      );
      final Map<String, Object?> expectedJson = {
        'grandPrixId': grandPrixId,
        'qualiStandingsByDriverIds': qualiStandingsBySeasonDriverIds,
        'p1DriverId': p1SeasonDriverId,
        'p2DriverId': p2SeasonDriverId,
        'p3DriverId': p3SeasonDriverId,
        'p10DriverId': p10SeasonDriverId,
        'fastestLapDriverId': fastestLapSeasonDriverId,
        'dnfDriverIds': dnfSeasonDriverIds,
        'willBeSafetyCar': willBeSafetyCar,
        'willBeRedFlag': willBeRedFlag
      };

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
