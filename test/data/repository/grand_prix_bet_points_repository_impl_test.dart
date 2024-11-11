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
    'getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes, '
    'should emit bet points which already exists in repo state and should fetch '
    'bet points which do not exist in repo state',
    () async {
      const String player1Id = 'p1';
      const String player2Id = 'p2';
      const String seasonGrandPrix1Id = 'gp1';
      const String seasonGrandPrix2Id = 'gp2';
      const List<GrandPrixBetPointsCreator> player1GpBetPointsCreators = [
        GrandPrixBetPointsCreator(
          id: '$player1Id$seasonGrandPrix1Id',
          playerId: player1Id,
          seasonGrandPrixId: seasonGrandPrix1Id,
        ),
        GrandPrixBetPointsCreator(
          id: '$player1Id$seasonGrandPrix2Id',
          playerId: player1Id,
          seasonGrandPrixId: seasonGrandPrix2Id,
        ),
      ];
      const List<GrandPrixBetPointsCreator> player2GpBetPointsCreators = [
        GrandPrixBetPointsCreator(
          id: '$player2Id$seasonGrandPrix1Id',
          playerId: player2Id,
          seasonGrandPrixId: seasonGrandPrix1Id,
        ),
        GrandPrixBetPointsCreator(
          id: '$player2Id$seasonGrandPrix2Id',
          playerId: player2Id,
          seasonGrandPrixId: seasonGrandPrix2Id,
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
        () => dbBetPointsService
            .fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId(
          playerId: player1Id,
          seasonGrandPrixId: seasonGrandPrix1Id,
        ),
      ).thenAnswer((_) => Future.value(player1GpBetPointsDtos.first));
      when(
        () => dbBetPointsService
            .fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId(
          playerId: player1Id,
          seasonGrandPrixId: seasonGrandPrix2Id,
        ),
      ).thenAnswer((_) => Future.value(player1GpBetPointsDtos.last));
      when(
        () => dbBetPointsService
            .fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId(
          playerId: player2Id,
          seasonGrandPrixId: seasonGrandPrix1Id,
        ),
      ).thenAnswer((_) => Future.value(player2GpBetPointsDtos.first));
      when(
        () => dbBetPointsService
            .fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId(
          playerId: player2Id,
          seasonGrandPrixId: seasonGrandPrix2Id,
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
          repositoryImpl.getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
        idsOfPlayers: [player1Id, player2Id],
        idsOfSeasonGrandPrixes: [seasonGrandPrix1Id],
      );
      final Stream<List<GrandPrixBetPoints>> gpBetPoints2$ =
          repositoryImpl.getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
        idsOfPlayers: [player1Id, player2Id],
        idsOfSeasonGrandPrixes: [seasonGrandPrix1Id, seasonGrandPrix2Id],
      );

      expect(await gpBetPoints1$.first, expectedGpBetPoints1);
      expect(await gpBetPoints2$.first, expectedGpBetPoints2);
      expect(await repositoryImpl.repositoryState$.first, expectedGpBetPoints2);
      verify(
        () => dbBetPointsService
            .fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId(
          playerId: player1Id,
          seasonGrandPrixId: seasonGrandPrix1Id,
        ),
      ).called(1);
      verify(
        () => dbBetPointsService
            .fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId(
          playerId: player1Id,
          seasonGrandPrixId: seasonGrandPrix2Id,
        ),
      ).called(1);
      verify(
        () => dbBetPointsService
            .fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId(
          playerId: player2Id,
          seasonGrandPrixId: seasonGrandPrix1Id,
        ),
      ).called(1);
      verify(
        () => dbBetPointsService
            .fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId(
          playerId: player2Id,
          seasonGrandPrixId: seasonGrandPrix2Id,
        ),
      ).called(1);
    },
  );

  group(
    'getGrandPrixBetPointsForPlayerAndSeasonGrandPrix, ',
    () {
      const String playerId = 'p1';
      const String grandPrixId = 'gp2';
      const GrandPrixBetPointsCreator grandPrixBetPointsCreator =
          GrandPrixBetPointsCreator(
        id: '$playerId$grandPrixId',
        playerId: playerId,
        seasonGrandPrixId: grandPrixId,
      );
      final List<GrandPrixBetPoints> existingEntities = [
        const GrandPrixBetPointsCreator(
          id: '${playerId}gp1',
          playerId: playerId,
          seasonGrandPrixId: 'gp1',
        ).createEntity(),
        const GrandPrixBetPointsCreator(
          id: 'p2$grandPrixId',
          playerId: 'p2',
          seasonGrandPrixId: grandPrixId,
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
              repositoryImpl.getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
            playerId: playerId,
            seasonGrandPrixId: grandPrixId,
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
              .mockFetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId(
            grandPrixBetPointsDto: grandPrixBetPointsDto,
          );
          grandPrixBetPointsMapper.mockMapFromDto(
            expectedGrandPrixBetPoints: expectedGrandPrixBetPoints,
          );
          repositoryImpl.addEntities(existingEntities);

          final Stream<GrandPrixBetPoints?> points$ =
              repositoryImpl.getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
            playerId: playerId,
            seasonGrandPrixId: grandPrixId,
          );

          expect(await points$.first, expectedGrandPrixBetPoints);
          expect(
            await repositoryImpl.repositoryState$.first,
            [...existingEntities, expectedGrandPrixBetPoints],
          );
          verify(
            () => dbBetPointsService
                .fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId(
              playerId: playerId,
              seasonGrandPrixId: grandPrixId,
            ),
          ).called(1);
        },
      );
    },
  );
}
