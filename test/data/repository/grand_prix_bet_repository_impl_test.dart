import 'package:betgrid/data/firebase/model/grand_prix_bet_dto.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository_impl.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_bet_creator.dart';
import '../../mock/data/mapper/mock_grand_prix_bet_mapper.dart';
import '../../mock/firebase/mock_firebase_grand_prix_bet_service.dart';

void main() {
  final dbGrandPrixBetService = MockFirebaseGrandPrixBetService();
  final grandPrixBetMapper = MockGrandPrixBetMapper();
  late GrandPrixBetRepositoryImpl repositoryImpl;
  const String playerId = 'u1';

  setUp(() {
    repositoryImpl = GrandPrixBetRepositoryImpl(
      dbGrandPrixBetService,
      grandPrixBetMapper,
    );
  });

  tearDown(() {
    reset(dbGrandPrixBetService);
    reset(grandPrixBetMapper);
  });

  group(
    'getAllGrandPrixBetsForPlayer, ',
    () {
      final List<GrandPrixBetCreator> grandPrixBetCreators = [
        GrandPrixBetCreator(id: 'gpb1', grandPrixId: 'gp1'),
        GrandPrixBetCreator(id: 'gpb2', grandPrixId: 'gp2'),
        GrandPrixBetCreator(id: 'gpb3', grandPrixId: 'gp3'),
      ];

      test(
        'should only emit matching grand prix bets if repo state is not empty',
        () async {
          final List<GrandPrixBet> existingGrandPrixBets = grandPrixBetCreators
              .map((creator) => creator.createEntity())
              .toList();
          repositoryImpl.addEntities(existingGrandPrixBets);

          final Stream<List<GrandPrixBet>?> grandPrixBets$ =
              repositoryImpl.getAllGrandPrixBetsForPlayer(playerId: playerId);

          expect(await grandPrixBets$.first, existingGrandPrixBets);
        },
      );

      test(
        'should fetch grand prix bets from db, add them to repo state and emit '
        'them if repo state is empty',
        () async {
          final List<GrandPrixBetDto> grandPrixBetDtos = grandPrixBetCreators
              .map((creator) => creator.createDto())
              .toList();
          final List<GrandPrixBet> expectedGrandPrixBets = grandPrixBetCreators
              .map((creator) => creator.createEntity())
              .toList();
          dbGrandPrixBetService.mockFetchAllGrandPrixBets(grandPrixBetDtos);
          when(
            () => grandPrixBetMapper.mapFromDto(grandPrixBetDtos.first),
          ).thenReturn(expectedGrandPrixBets.first);
          when(
            () => grandPrixBetMapper.mapFromDto(grandPrixBetDtos[1]),
          ).thenReturn(expectedGrandPrixBets[1]);
          when(
            () => grandPrixBetMapper.mapFromDto(grandPrixBetDtos.last),
          ).thenReturn(expectedGrandPrixBets.last);

          final Stream<List<GrandPrixBet>?> grandPrixBets$ =
              repositoryImpl.getAllGrandPrixBetsForPlayer(playerId: playerId);

          expect(await grandPrixBets$.first, expectedGrandPrixBets);
          expect(
            await repositoryImpl.repositoryState$.first,
            expectedGrandPrixBets,
          );
          verify(
            () => dbGrandPrixBetService.fetchAllGrandPrixBets(userId: playerId),
          ).called(1);
        },
      );
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
          id: '$player1Id$gp1Id',
          playerId: player1Id,
          grandPrixId: gp1Id,
        ),
        GrandPrixBetCreator(
          id: '$player1Id$gp2Id',
          playerId: player1Id,
          grandPrixId: gp2Id,
        ),
      ];
      final List<GrandPrixBetCreator> player2GpBetCreators = [
        GrandPrixBetCreator(
          id: '$player2Id$gp1Id',
          playerId: player2Id,
          grandPrixId: gp1Id,
        ),
        GrandPrixBetCreator(
          id: '$player2Id$gp2Id',
          playerId: player2Id,
          grandPrixId: gp2Id,
        ),
      ];
      final List<GrandPrixBetDto> player1GpBetDtos =
          player1GpBetCreators.map((creator) => creator.createDto()).toList();
      final List<GrandPrixBetDto> player2GpBetDtos =
          player2GpBetCreators.map((creator) => creator.createDto()).toList();
      final List<GrandPrixBet> player1GpBets = player1GpBetCreators
          .map((creator) => creator.createEntity())
          .toList();
      final List<GrandPrixBet> player2GpBets = player2GpBetCreators
          .map((creator) => creator.createEntity())
          .toList();
      final List<GrandPrixBet> expectedGpBets1 = [
        player1GpBets.first,
        player2GpBets.first,
      ];
      final List<GrandPrixBet> expectedGpBets2 = [
        player1GpBets.first,
        player2GpBets.first,
        player1GpBets.last,
        player2GpBets.last,
      ];
      when(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp1Id,
        ),
      ).thenAnswer((_) => Future.value(player1GpBetDtos.first));
      when(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp2Id,
        ),
      ).thenAnswer((_) => Future.value(player1GpBetDtos.last));
      when(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp1Id,
        ),
      ).thenAnswer((_) => Future.value(player2GpBetDtos.first));
      when(
        () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp2Id,
        ),
      ).thenAnswer((_) => Future.value(player2GpBetDtos.last));
      when(
        () => grandPrixBetMapper.mapFromDto(player1GpBetDtos.first),
      ).thenReturn(player1GpBets.first);
      when(
        () => grandPrixBetMapper.mapFromDto(player1GpBetDtos.last),
      ).thenReturn(player1GpBets.last);
      when(
        () => grandPrixBetMapper.mapFromDto(player2GpBetDtos.first),
      ).thenReturn(player2GpBets.first);
      when(
        () => grandPrixBetMapper.mapFromDto(player2GpBetDtos.last),
      ).thenReturn(player2GpBets.last);

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

  group(
    'getGrandPrixBetForPlayerAndGrandPrix, ',
    () {
      const String grandPrixId = 'gp1';
      final GrandPrixBetCreator grandPrixBetCreator = GrandPrixBetCreator(
        id: 'gpb1',
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      final List<GrandPrixBet> existingEntities = [
        GrandPrixBetCreator(
          id: 'gpb2',
          playerId: 'p2',
          grandPrixId: grandPrixId,
        ).createEntity(),
        GrandPrixBetCreator(
          id: 'gpb3',
          playerId: playerId,
          grandPrixId: 'gp2',
        ).createEntity(),
      ];

      test(
        'should emit first matching grand prix if it already exists in repo '
        'state',
        () async {
          final GrandPrixBet existingGrandPrixBet =
              grandPrixBetCreator.createEntity();
          repositoryImpl.addEntities(
            [...existingEntities, existingGrandPrixBet],
          );

          final Stream<GrandPrixBet?> grandPrixBet$ =
              repositoryImpl.getGrandPrixBetForPlayerAndGrandPrix(
            playerId: playerId,
            grandPrixId: grandPrixId,
          );

          expect(await grandPrixBet$.first, existingGrandPrixBet);
        },
      );

      test(
        'should fetch gp bet from db, add it to repo state and emit it if '
        'there is no matching gp bet in repo state',
        () async {
          final GrandPrixBetDto grandPrixBetDto =
              grandPrixBetCreator.createDto();
          final GrandPrixBet expectedGrandPrixBet =
              grandPrixBetCreator.createEntity();
          dbGrandPrixBetService
              .mockFetchGrandPrixBetByGrandPrixId(grandPrixBetDto);
          grandPrixBetMapper.mockMapFromDto(
            expectedGrandPrixBet: expectedGrandPrixBet,
          );
          repositoryImpl.addEntities(existingEntities);

          final Stream<GrandPrixBet?> grandPrixBet$ =
              repositoryImpl.getGrandPrixBetForPlayerAndGrandPrix(
            playerId: playerId,
            grandPrixId: grandPrixId,
          );

          expect(await grandPrixBet$.first, expectedGrandPrixBet);
          expect(
            await repositoryImpl.repositoryState$.first,
            [...existingEntities, expectedGrandPrixBet],
          );
          verify(
            () => dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
              playerId: playerId,
              grandPrixId: grandPrixId,
            ),
          ).called(1);
        },
      );
    },
  );
}
