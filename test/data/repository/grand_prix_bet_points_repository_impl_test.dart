import 'package:betgrid/data/firebase/model/grand_prix_bet_points_dto.dart';
import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_impl.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_bet_points_creator.dart';
import '../../mock/data/mapper/mock_grand_prix_bet_points_mapper.dart';
import '../../mock/data/repository/mock_firebase_grand_prix_bet_points_service.dart';

void main() {
  final dbBetPointsService = MockFirebaseGrandPrixBetPointsService();
  final grandPrixBetPointsMapper = MockGrandPrixBetPointsMapper();
  late GrandPrixBetPointsRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = GrandPrixBetPointsRepositoryImpl(
      dbBetPointsService,
      grandPrixBetPointsMapper,
    );
  });

  tearDown(() {
    reset(dbBetPointsService);
    reset(grandPrixBetPointsMapper);
  });

  test(
    'getGrandPrixBetPointsForPlayersAndGrandPrixes, '
    'should emit bet points which already exists in repo state and should fetch '
    'bet points which do not exist in repo state',
    () async {
      const String player1Id = 'p1';
      const String player2Id = 'p2';
      const String gp1Id = 'gp1';
      const String gp2Id = 'gp2';
      final List<GrandPrixBetPointsCreator> player1GpBetPointsCreators = [
        GrandPrixBetPointsCreator(
          id: '$player1Id$gp1Id',
          playerId: player1Id,
          grandPrixId: gp1Id,
        ),
        GrandPrixBetPointsCreator(
          id: '$player1Id$gp2Id',
          playerId: player1Id,
          grandPrixId: gp2Id,
        ),
      ];
      final List<GrandPrixBetPointsCreator> player2GpBetPointsCreators = [
        GrandPrixBetPointsCreator(
          id: '$player2Id$gp1Id',
          playerId: player2Id,
          grandPrixId: gp1Id,
        ),
        GrandPrixBetPointsCreator(
          id: '$player2Id$gp2Id',
          playerId: player2Id,
          grandPrixId: gp2Id,
        ),
      ];
      final List<GrandPrixBetPointsDto> player1GpBetPointsDtos =
          player1GpBetPointsCreators
              .map((creator) => creator.createDto())
              .toList();
      final List<GrandPrixBetPointsDto> player2GpBetPointsDtos =
          player2GpBetPointsCreators
              .map((creator) => creator.createDto())
              .toList();
      final List<GrandPrixBetPoints> player1GpBetPoints =
          player1GpBetPointsCreators
              .map((creator) => creator.createEntity())
              .toList();
      final List<GrandPrixBetPoints> player2GpBetPoints =
          player2GpBetPointsCreators
              .map((creator) => creator.createEntity())
              .toList();
      final List<GrandPrixBetPoints> expectedGpBetPoints1 = [
        player1GpBetPoints.first,
        player2GpBetPoints.first,
      ];
      final List<GrandPrixBetPoints> expectedGpBetPoints2 = [
        player1GpBetPoints.first,
        player2GpBetPoints.first,
        player1GpBetPoints.last,
        player2GpBetPoints.last,
      ];
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp1Id,
        ),
      ).thenAnswer((_) => Future.value(player1GpBetPointsDtos.first));
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp2Id,
        ),
      ).thenAnswer((_) => Future.value(player1GpBetPointsDtos.last));
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp1Id,
        ),
      ).thenAnswer((_) => Future.value(player2GpBetPointsDtos.first));
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp2Id,
        ),
      ).thenAnswer((_) => Future.value(player2GpBetPointsDtos.last));
      when(
        () => grandPrixBetPointsMapper.mapFromDto(player1GpBetPointsDtos.first),
      ).thenReturn(player1GpBetPoints.first);
      when(
        () => grandPrixBetPointsMapper.mapFromDto(player1GpBetPointsDtos.last),
      ).thenReturn(player1GpBetPoints.last);
      when(
        () => grandPrixBetPointsMapper.mapFromDto(player2GpBetPointsDtos.first),
      ).thenReturn(player2GpBetPoints.first);
      when(
        () => grandPrixBetPointsMapper.mapFromDto(player2GpBetPointsDtos.last),
      ).thenReturn(player2GpBetPoints.last);

      final Stream<List<GrandPrixBetPoints>> gpBetPoints1$ =
          repositoryImpl.getGrandPrixBetPointsForPlayersAndGrandPrixes(
        idsOfPlayers: [player1Id, player2Id],
        idsOfGrandPrixes: [gp1Id],
      );
      final Stream<List<GrandPrixBetPoints>> gpBetPoints2$ =
          repositoryImpl.getGrandPrixBetPointsForPlayersAndGrandPrixes(
        idsOfPlayers: [player1Id, player2Id],
        idsOfGrandPrixes: [gp1Id, gp2Id],
      );

      expect(await gpBetPoints1$.first, expectedGpBetPoints1);
      expect(await gpBetPoints2$.first, expectedGpBetPoints2);
      expect(await repositoryImpl.repositoryState$.first, expectedGpBetPoints2);
      verify(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp1Id,
        ),
      ).called(1);
      verify(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp2Id,
        ),
      ).called(1);
      verify(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp1Id,
        ),
      ).called(1);
      verify(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp2Id,
        ),
      ).called(1);
    },
  );

  group(
    'getGrandPrixBetPointsForPlayerAndGrandPrix, ',
    () {
      const String playerId = 'p1';
      const String grandPrixId = 'gp2';
      final GrandPrixBetPointsCreator grandPrixBetPointsCreator =
          GrandPrixBetPointsCreator(
        id: '$playerId$grandPrixId',
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      final List<GrandPrixBetPoints> existingEntities = [
        GrandPrixBetPointsCreator(
          id: '${playerId}gp1',
          playerId: playerId,
          grandPrixId: 'gp1',
        ).createEntity(),
        GrandPrixBetPointsCreator(
          id: 'p2$grandPrixId',
          playerId: 'p2',
          grandPrixId: grandPrixId,
        ).createEntity(),
      ];

      test(
        'should only emit grand prix bet points if it already exists in repo state',
        () async {
          final GrandPrixBetPoints existingGrandPrixBetPoints =
              grandPrixBetPointsCreator.createEntity();
          repositoryImpl.addEntities(
            [...existingEntities, existingGrandPrixBetPoints],
          );

          final Stream<GrandPrixBetPoints?> points$ =
              repositoryImpl.getGrandPrixBetPointsForPlayerAndGrandPrix(
            playerId: playerId,
            grandPrixId: grandPrixId,
          );

          expect(await points$.first, existingGrandPrixBetPoints);
        },
      );

      test(
        'should fetch grand prix bet points from db, add it to repo state and '
        'emit it if it does not exist in repo state',
        () async {
          final GrandPrixBetPointsDto grandPrixBetPointsDto =
              grandPrixBetPointsCreator.createDto();
          final GrandPrixBetPoints expectedGrandPrixBetPoints =
              grandPrixBetPointsCreator.createEntity();
          dbBetPointsService
              .mockFetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
            grandPrixBetPointsDto: grandPrixBetPointsDto,
          );
          grandPrixBetPointsMapper.mockMapFromDto(
            expectedGrandPrixBetPoints: expectedGrandPrixBetPoints,
          );
          repositoryImpl.addEntities(existingEntities);

          final Stream<GrandPrixBetPoints?> points$ =
              repositoryImpl.getGrandPrixBetPointsForPlayerAndGrandPrix(
            playerId: playerId,
            grandPrixId: grandPrixId,
          );

          expect(await points$.first, expectedGrandPrixBetPoints);
          expect(
            await repositoryImpl.repositoryState$.first,
            [...existingEntities, expectedGrandPrixBetPoints],
          );
          verify(
            () => dbBetPointsService
                .fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
              playerId: playerId,
              grandPrixId: grandPrixId,
            ),
          ).called(1);
        },
      );
    },
  );
}
