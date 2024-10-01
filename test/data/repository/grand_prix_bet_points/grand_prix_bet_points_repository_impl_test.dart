import 'package:betgrid/data/firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_impl.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../mock/data/repository/mock_firebase_grand_prix_bet_points_service.dart';

void main() {
  final dbBetPointsService = MockFirebaseGrandPrixBetPointsService();
  late GrandPrixBetPointsRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = GrandPrixBetPointsRepositoryImpl(dbBetPointsService);
  });

  tearDown(() {
    reset(dbBetPointsService);
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
      final List<GrandPrixBetPoints> expectedGpBetPoints1 = [
        player1GpBetPointsCreators.first.createEntity(),
        player2GpBetPointsCreators.first.createEntity(),
      ];
      final List<GrandPrixBetPoints> expectedGpBetPoints2 = [
        player1GpBetPointsCreators.first.createEntity(),
        player2GpBetPointsCreators.first.createEntity(),
        player1GpBetPointsCreators.last.createEntity(),
        player2GpBetPointsCreators.last.createEntity(),
      ];
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp1Id,
        ),
      ).thenAnswer(
        (_) => Future.value(player1GpBetPointsCreators.first.createDto()),
      );
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player1Id,
          grandPrixId: gp2Id,
        ),
      ).thenAnswer(
        (_) => Future.value(player1GpBetPointsCreators.last.createDto()),
      );
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp1Id,
        ),
      ).thenAnswer(
        (_) => Future.value(player2GpBetPointsCreators.first.createDto()),
      );
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: player2Id,
          grandPrixId: gp2Id,
        ),
      ).thenAnswer(
        (_) => Future.value(player2GpBetPointsCreators.last.createDto()),
      );

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

  test(
    'getGrandPrixBetPointsForPlayerAndGrandPrix, '
    'should load grand prix bet points from db, add it to repo state and emit it '
    'if it does not exist in repo state, '
    'should only emit grand prix bet points if it already exists in repo state, ',
    () async {
      const String playerId = 'p1';
      const String grandPrixId = 'gp2';
      final GrandPrixBetPointsCreator grandPrixBetPointsCreator =
          GrandPrixBetPointsCreator(
        id: grandPrixId,
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      final GrandPrixBetPointsDto grandPrixBetPointsDto =
          grandPrixBetPointsCreator.createDto();
      final GrandPrixBetPoints expectedGrandPrixBetPoints =
          grandPrixBetPointsCreator.createEntity();
      dbBetPointsService.mockFetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
        grandPrixBetPointsDto: grandPrixBetPointsDto,
      );

      final Stream<GrandPrixBetPoints?> points1$ =
          repositoryImpl.getGrandPrixBetPointsForPlayerAndGrandPrix(
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      final Stream<GrandPrixBetPoints?> points2$ =
          repositoryImpl.getGrandPrixBetPointsForPlayerAndGrandPrix(
        playerId: playerId,
        grandPrixId: grandPrixId,
      );

      expect(await points1$.first, expectedGrandPrixBetPoints);
      expect(await points2$.first, expectedGrandPrixBetPoints);
      expect(
        await repositoryImpl.repositoryState$.first,
        [expectedGrandPrixBetPoints],
      );
      verify(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );
}
