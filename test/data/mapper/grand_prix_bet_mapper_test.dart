import 'package:betgrid/data/firebase/model/grand_prix_bet_dto.dart';
import 'package:betgrid/data/mapper/grand_prix_bet_mapper.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'gpb1';
  const String playerId = 'p1';
  const String grandPrixId = 'gp1';
  final List<String?> qualiStandingsByDriverIds = List.generate(
    20,
    (index) => switch (index) {
      1 => 'd2',
      4 => 'd10',
      11 => 'd4',
      _ => null,
    },
  );
  const String p1DriverId = 'd1';
  const String p2DriverId = 'd2';
  const String p3DriverId = 'd3';
  const String p10DriverId = 'd4';
  const String fastestLapDriverId = 'd1';
  const List<String> dnfDriverIds = ['d10', 'd11', 'd12'];
  const bool willBeSafetyCar = true;
  const bool willBeRedFlag = false;
  final mapper = GrandPrixBetMapper();

  test(
    'mapFromDto, '
    'should map GrandPrixBetDto model to GrandPrixBet model',
    () {
      final GrandPrixBetDto grandPrixBetDto = GrandPrixBetDto(
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
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );
      final GrandPrixBet expectedGrandPrixBet = GrandPrixBet(
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
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );

      final GrandPrixBet grandPrixBet = mapper.mapFromDto(grandPrixBetDto);

      expect(grandPrixBet, expectedGrandPrixBet);
    },
  );

  test(
    'mapToDto, '
    'should map GrandPrixBet model to GrandPrixBetDto model',
    () {
      final GrandPrixBet grandPrixBet = GrandPrixBet(
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
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );
      final GrandPrixBetDto expectedDto = GrandPrixBetDto(
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
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );

      final GrandPrixBetDto dto = mapper.mapToDto(grandPrixBet);

      expect(dto, expectedDto);
    },
  );
}
