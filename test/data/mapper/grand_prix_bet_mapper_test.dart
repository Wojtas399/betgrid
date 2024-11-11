import 'package:betgrid/data/firebase/model/grand_prix_bet_dto.dart';
import 'package:betgrid/data/mapper/grand_prix_bet_mapper.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'gpb1';
  const String playerId = 'p1';
  const String seasonGrandPrixId = 'gp1';
  final List<String?> qualiStandingsBySeasonDriverIds = List.generate(
    20,
    (index) => switch (index) {
      1 => 'd2',
      4 => 'd10',
      11 => 'd4',
      _ => null,
    },
  );
  const String p1SeasonDriverId = 'd1';
  const String p2SeasonDriverId = 'd2';
  const String p3SeasonDriverId = 'd3';
  const String p10SeasonDriverId = 'd4';
  const String fastestLapSeasonDriverId = 'd1';
  const List<String> dnfSeasonDriverIds = ['d10', 'd11', 'd12'];
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
        grandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );
      final GrandPrixBet expectedGrandPrixBet = GrandPrixBet(
        id: id,
        playerId: playerId,
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
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
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );
      final GrandPrixBetDto expectedDto = GrandPrixBetDto(
        id: id,
        playerId: playerId,
        grandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        willBeSafetyCar: willBeSafetyCar,
        willBeRedFlag: willBeRedFlag,
      );

      final GrandPrixBetDto dto = mapper.mapToDto(grandPrixBet);

      expect(dto, expectedDto);
    },
  );
}
