import 'package:betgrid/data/firebase/model/grand_prix_bet_dto/grand_prix_bet_dto.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository_impl.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_creator.dart';
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
      final List<GrandPrixBetCreator> grandPrixBetCreators = [
        GrandPrixBetCreator(id: 'gpb1', grandPrixId: 'gp1'),
        GrandPrixBetCreator(id: 'gpb2', grandPrixId: 'gp2'),
        GrandPrixBetCreator(id: 'gpb3', grandPrixId: 'gp3'),
      ];
      final List<GrandPrixBetDto> grandPrixBetDtos =
          grandPrixBetCreators.map((creator) => creator.createDto()).toList();
      final List<GrandPrixBet> expectedGrandPrixBets = grandPrixBetCreators
          .map((creator) => creator.createEntity())
          .toList();
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
    'getGrandPrixBetsForPlayersAndGrandPrixes, '
    'should emit bets which already exists in repo state and should fetch bets '
    'which do not exist in repo state',
    () async {
      const String player1Id = 'p1';
      const String player2Id = 'p2';
      const String gp1Id = 'gp1';
      const String gp2Id = 'gp2';
      final List<GrandPrixBetCreator> player1GpBetCreators = [
        GrandPrixBetCreator(
          id: 'p1gp1',
          playerId: player1Id,
          grandPrixId: gp1Id,
        ),
        GrandPrixBetCreator(
          id: 'p1gp2',
          playerId: player1Id,
          grandPrixId: gp2Id,
        ),
      ];
      final List<GrandPrixBetCreator> player2GpBetCreators = [
        GrandPrixBetCreator(
          id: 'p2gp1',
          playerId: player2Id,
          grandPrixId: gp1Id,
        ),
        GrandPrixBetCreator(
          id: 'p2gp2',
          playerId: player2Id,
          grandPrixId: gp2Id,
        ),
      ];
      final player1Gp1BetDto = player1GpBetCreators.first.createDto();
      final player1Gp2BetDto = player1GpBetCreators.last.createDto();
      final player2Gp1BetDto = player2GpBetCreators.first.createDto();
      final player2Gp2BetDto = player2GpBetCreators.last.createDto();
      final List<GrandPrixBet> expectedGpBets1 = [
        player1GpBetCreators.first.createEntity(),
        player2GpBetCreators.first.createEntity(),
      ];
      final List<GrandPrixBet> expectedGpBets2 = [
        player1GpBetCreators.first.createEntity(),
        player2GpBetCreators.first.createEntity(),
        player1GpBetCreators.last.createEntity(),
        player2GpBetCreators.last.createEntity(),
      ];
      when(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp1Id,
        ),
      ).thenAnswer((_) => Future.value(player1Gp1BetDto));
      when(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp2Id,
        ),
      ).thenAnswer((_) => Future.value(player1Gp2BetDto));
      when(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp1Id,
        ),
      ).thenAnswer((_) => Future.value(player2Gp1BetDto));
      when(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp2Id,
        ),
      ).thenAnswer((_) => Future.value(player2Gp2BetDto));

      final Stream<List<GrandPrixBet>> gpBets1$ =
          repositoryImpl.getGrandPrixBetsForPlayersAndGrandPrixes(
        idsOfPlayers: [player1Id, player2Id],
        idsOfGrandPrixes: [gp1Id],
      );
      final Stream<List<GrandPrixBet>> gpBets2$ =
          repositoryImpl.getGrandPrixBetsForPlayersAndGrandPrixes(
        idsOfPlayers: [player1Id, player2Id],
        idsOfGrandPrixes: [gp1Id, gp2Id],
      );

      expect(await gpBets1$.first, expectedGpBets1);
      expect(await gpBets2$.first, expectedGpBets2);
      expect(await repositoryImpl.repositoryState$.first, expectedGpBets2);
      verify(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp1Id,
        ),
      ).called(1);
      verify(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp2Id,
        ),
      ).called(1);
      verify(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp1Id,
        ),
      ).called(1);
      verify(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp2Id,
        ),
      ).called(1);
    },
  );

  test(
    'getGrandPrixBetForPlayerAndGrandPrix, '
    'bet with matching grand prix id and player id exists in state, '
    'should load gp bet from db, add it to repo state and emit it if there is no '
    'matching gp bet in repo state, '
    'should return first matching grand prix bet if it exists in repo state, ',
    () async {
      const String grandPrixId = 'gp1';
      final GrandPrixBetCreator grandPrixBetCreator = GrandPrixBetCreator(
        id: 'gpb1',
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      final GrandPrixBetDto grandPrixBetDto = grandPrixBetCreator.createDto();
      final GrandPrixBet expectedGrandPrixBet =
          grandPrixBetCreator.createEntity();
      dbGrandPrixBetService.mockFetchGrandPrixBetByGrandPrixId(grandPrixBetDto);

      final Stream<GrandPrixBet?> grandPrixBet1$ =
          repositoryImpl.getGrandPrixBetForPlayerAndGrandPrix(
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      final Stream<GrandPrixBet?> grandPrixBet2$ =
          repositoryImpl.getGrandPrixBetForPlayerAndGrandPrix(
        playerId: playerId,
        grandPrixId: grandPrixId,
      );

      expect(await grandPrixBet1$.first, expectedGrandPrixBet);
      expect(await grandPrixBet2$.first, expectedGrandPrixBet);
      expect(
        await repositoryImpl.repositoryState$.first,
        [expectedGrandPrixBet],
      );
      verify(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'addGrandPrixBetsForPlayer, '
    'for each grand prix bet should call db method to add this bet to db and to '
    'repo state',
    () async {
      final List<GrandPrixBetCreator> grandPrixBetCreators = [
        GrandPrixBetCreator(id: 'gpb1'),
        GrandPrixBetCreator(id: 'gpb2'),
        GrandPrixBetCreator(id: 'gpb3'),
      ];
      final List<GrandPrixBet> grandPrixBets = grandPrixBetCreators
          .map((creator) => creator.createEntity())
          .toList();
      final List<GrandPrixBetDto> grandPrixBetDtos =
          grandPrixBetCreators.map((creator) => creator.createDto()).toList();
      dbGrandPrixBetService.mockAddGrandPrixBet();

      await repositoryImpl.addGrandPrixBetsForPlayer(
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
}
