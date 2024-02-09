import 'package:betgrid/data/mapper/grand_prix_bet_mapper.dart';
import 'package:betgrid/firebase/model/grand_prix_bet/grand_prix_bet_dto.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'gpb1';
  const String grandPrixId = 'gp1';
  const List<String> qualiStandingsByDriverIds = ['d1', 'd3', 'd2'];
  const String p1DriverId = 'd1';
  const String p2DriverId = 'd2';
  const String p3DriverId = 'd3';
  const String p10DriverId = 'd4';
  const String fastestLapDriverId = 'd1';
  const bool willBeDnf = false;
  const bool willBeSafetyCar = true;
  const bool willBeRedFlag = false;

  test(
    'mapGrandPrixBetToDto, '
    'should map GrandPrixBet model to GrandPrixBetDto model',
    () {
      const GrandPrixBet grandPrixBet = GrandPrixBet(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        willBeDnf: willBeDnf,
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );
      const GrandPrixBetDto expectedDto = GrandPrixBetDto(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        willBeDnf: willBeDnf,
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );

      final GrandPrixBetDto dto = mapGrandPrixBetToDto(grandPrixBet);

      expect(dto, expectedDto);
    },
  );
}
