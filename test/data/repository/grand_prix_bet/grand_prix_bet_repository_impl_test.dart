import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository_impl.dart';
import 'package:betgrid/firebase/model/grand_prix_bet_dto/grand_prix_bet_dto.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_bet_dto_creator.dart';
import '../../../mock/firebase/mock_firebase_grand_prix_bet_service.dart';

void main() {
  final dbGrandPrixBetService = MockFirebaseGrandPrixBetService();
  late GrandPrixBetRepositoryImpl repositoryImpl;
  const String playerId = 'u1';

  setUp(() {
    repositoryImpl = GrandPrixBetRepositoryImpl(dbGrandPrixBetService);
  });

  tearDown(() {
    reset(dbGrandPrixBetService);
  });

  test(
    'getAllGrandPrixBetsForPlayer, '
    'repository state is empty, '
    'should load grand prix bets from db, add them to repo state and emit them '
    'if repo state is empty, '
    "should only emit player's grand prix bets if their exist in repo state",
    () async {
      final List<GrandPrixBetDto> grandPrixBetDtos = [
        createGrandPrixBetDto(id: 'gpb1', grandPrixId: 'gp1'),
        createGrandPrixBetDto(id: 'gpb2', grandPrixId: 'gp2'),
        createGrandPrixBetDto(id: 'gpb3', grandPrixId: 'gp3'),
      ];
      final List<GrandPrixBet> expectedGrandPrixBets = [
        createGrandPrixBet(id: 'gpb1', grandPrixId: 'gp1'),
        createGrandPrixBet(id: 'gpb2', grandPrixId: 'gp2'),
        createGrandPrixBet(id: 'gpb3', grandPrixId: 'gp3'),
      ];
      dbGrandPrixBetService.mockFetchAllGrandPrixBets(grandPrixBetDtos);

      final Stream<List<GrandPrixBet>?> grandPrixBets1$ =
          repositoryImpl.getAllGrandPrixBetsForPlayer(playerId: playerId);
      final Stream<List<GrandPrixBet>?> grandPrixBets2$ =
          repositoryImpl.getAllGrandPrixBetsForPlayer(playerId: playerId);

      expect(await grandPrixBets1$.first, expectedGrandPrixBets);
      expect(await grandPrixBets2$.first, expectedGrandPrixBets);
      expect(
        await repositoryImpl.repositoryState$.first,
        expectedGrandPrixBets,
      );
      verify(
        () => dbGrandPrixBetService.fetchAllGrandPrixBets(userId: playerId),
      ).called(1);
    },
  );

  test(
    'getBetByGrandPrixIdAndPlayerId, '
    'bet with matching grand prix id and player id exists in state, '
    'should load gp bet from db, add it to repo state and emit it if there is no '
    'matching gp bet in repo state, '
    'should return first matching grand prix bet if it exists in repo state, ',
    () async {
      const String grandPrixId = 'gp1';
      final GrandPrixBetDto grandPrixBetDto = createGrandPrixBetDto(
        id: 'gpb1',
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      final GrandPrixBet expectedGrandPrixBet = createGrandPrixBet(
        id: 'gpb1',
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      dbGrandPrixBetService.mockFetchGrandPrixBetByGrandPrixId(grandPrixBetDto);

      final Stream<GrandPrixBet?> grandPrixBet1$ =
          repositoryImpl.getBetByGrandPrixIdAndPlayerId(
        playerId: playerId,
        grandPrixId: 'gp1',
      );
      final Stream<GrandPrixBet?> grandPrixBet2$ =
          repositoryImpl.getBetByGrandPrixIdAndPlayerId(
        playerId: playerId,
        grandPrixId: 'gp1',
      );

      expect(await grandPrixBet1$.first, expectedGrandPrixBet);
      expect(await grandPrixBet2$.first, expectedGrandPrixBet);
      expect(
        await repositoryImpl.repositoryState$.first,
        [expectedGrandPrixBet],
      );
      verify(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          userId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'addGrandPrixBets, '
    'for each grand prix bet should call db method to add this bet to db and to '
    'repo state',
    () async {
      final List<GrandPrixBet> grandPrixBets = [
        createGrandPrixBet(id: 'gpb1'),
        createGrandPrixBet(id: 'gpb2'),
        createGrandPrixBet(id: 'gpb3'),
      ];
      final List<GrandPrixBetDto> grandPrixBetDtos = [
        createGrandPrixBetDto(id: grandPrixBets[0].id),
        createGrandPrixBetDto(id: grandPrixBets[1].id),
        createGrandPrixBetDto(id: grandPrixBets[2].id),
      ];
      dbGrandPrixBetService.mockAddGrandPrixBet();

      await repositoryImpl.addGrandPrixBets(
        playerId: playerId,
        grandPrixBets: grandPrixBets,
      );

      expect(repositoryImpl.repositoryState$, emits(grandPrixBets));
      verify(
        () => dbGrandPrixBetService.addGrandPrixBet(
          userId: playerId,
          grandPrixBetDto: grandPrixBetDtos[0],
        ),
      ).called(1);
      verify(
        () => dbGrandPrixBetService.addGrandPrixBet(
          userId: playerId,
          grandPrixBetDto: grandPrixBetDtos[1],
        ),
      ).called(1);
      verify(
        () => dbGrandPrixBetService.addGrandPrixBet(
          userId: playerId,
          grandPrixBetDto: grandPrixBetDtos[2],
        ),
      ).called(1);
    },
  );

  test(
    'updateGrandPrixBet, '
    'should update bet in db and in repository state',
    () async {
      const String grandPrixBetId = 'gpb1';
      final List<String?> qualiStandingsByDriverIds = List.generate(
        20,
        (index) => switch (index) {
          2 => 'd3',
          6 => 'd1',
          8 => 'd4',
          _ => null,
        },
      );
      const String p1DriverId = 'd3';
      const String p2DriverId = 'd1';
      const String p3DriverId = 'd2';
      const String p10DriverId = 'd4';
      const String fastestLapDriverId = 'd10';
      const List<String> dnfDriverIds = ['d18', 'd19', 'd20'];
      const bool willBeSafetyCar = true;
      const bool willBeRedFlag = false;
      final GrandPrixBetDto updatedGrandPrixBetDto = createGrandPrixBetDto(
        id: grandPrixBetId,
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
      final GrandPrixBet updatedGrandPrixBet = createGrandPrixBet(
        id: grandPrixBetId,
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
      final List<GrandPrixBet> existingGrandPrixBets = [
        createGrandPrixBet(
          id: grandPrixBetId,
          qualiStandingsByDriverIds: List.generate(
            20,
            (index) => switch (index) {
              2 => 'd4',
              6 => 'd3',
              8 => 'd1',
              _ => null,
            },
          ),
          p1DriverId: 'd1',
          p2DriverId: 'd2',
          p3DriverId: 'd3',
          p10DriverId: 'd10',
          fastestLapDriverId: 'd4',
          dnfDriverIds: ['d15', 'd16', 'd17'],
          willBeSafetyCar: false,
          willBeRedFlag: true,
        ),
        createGrandPrixBet(id: 'gpb2'),
        createGrandPrixBet(id: 'gpb3'),
      ];
      dbGrandPrixBetService.mockAddGrandPrixBet();
      dbGrandPrixBetService.mockUpdateGrandPrixBet(updatedGrandPrixBetDto);

      await repositoryImpl.addGrandPrixBets(
        playerId: playerId,
        grandPrixBets: existingGrandPrixBets,
      );
      await repositoryImpl.updateGrandPrixBet(
        playerId: playerId,
        grandPrixBetId: grandPrixBetId,
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

      expect(
        repositoryImpl.repositoryState$,
        emits([
          updatedGrandPrixBet,
          existingGrandPrixBets[1],
          existingGrandPrixBets.last,
        ]),
      );
      verify(
        () => dbGrandPrixBetService.updateGrandPrixBet(
          userId: playerId,
          grandPrixBetId: grandPrixBetId,
          qualiStandingsByDriverIds: qualiStandingsByDriverIds,
          p1DriverId: p1DriverId,
          p2DriverId: p2DriverId,
          p3DriverId: p3DriverId,
          p10DriverId: p10DriverId,
          fastestLapDriverId: fastestLapDriverId,
          dnfDriverIds: dnfDriverIds,
          willBeSafetyCar: willBeSafetyCar,
          willBeRedFlag: willBeRedFlag,
        ),
      ).called(1);
    },
  );
}
