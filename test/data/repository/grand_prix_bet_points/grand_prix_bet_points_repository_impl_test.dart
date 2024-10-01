import 'package:betgrid/data/firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_impl.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_bet_points_dto_creator.dart';
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
      final GrandPrixBetPointsDto player1Gp1BetPointsDto =
          createGrandPrixBetPointsDto(
        id: 'p1gp1',
        playerId: 'p1',
        grandPrixId: 'gp1',
      );
      final GrandPrixBetPointsDto player1Gp2BetPointsDto =
          createGrandPrixBetPointsDto(
        id: 'p1gp2',
        playerId: 'p1',
        grandPrixId: 'gp2',
      );
      final GrandPrixBetPointsDto player2Gp1BetPointsDto =
          createGrandPrixBetPointsDto(
        id: 'p2gp1',
        playerId: 'p2',
        grandPrixId: 'gp1',
      );
      final GrandPrixBetPointsDto player2Gp2BetPointsDto =
          createGrandPrixBetPointsDto(
        id: 'p2gp2',
        playerId: 'p2',
        grandPrixId: 'gp2',
      );
      final List<GrandPrixBetPoints> expectedGpBetPoints1 = [
        createGrandPrixBetPoints(
          id: 'p1gp1',
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
        createGrandPrixBetPoints(
          id: 'p2gp1',
          playerId: 'p2',
          grandPrixId: 'gp1',
        )
      ];
      final List<GrandPrixBetPoints> expectedGpBetPoints2 = [
        createGrandPrixBetPoints(
          id: 'p1gp1',
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
        createGrandPrixBetPoints(
          id: 'p2gp1',
          playerId: 'p2',
          grandPrixId: 'gp1',
        ),
        createGrandPrixBetPoints(
          id: 'p1gp2',
          playerId: 'p1',
          grandPrixId: 'gp2',
        ),
        createGrandPrixBetPoints(
          id: 'p2gp2',
          playerId: 'p2',
          grandPrixId: 'gp2',
        ),
      ];
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
      ).thenAnswer((_) => Future.value(player1Gp1BetPointsDto));
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: 'p1',
          grandPrixId: 'gp2',
        ),
      ).thenAnswer((_) => Future.value(player1Gp2BetPointsDto));
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: 'p2',
          grandPrixId: 'gp1',
        ),
      ).thenAnswer((_) => Future.value(player2Gp1BetPointsDto));
      when(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: 'p2',
          grandPrixId: 'gp2',
        ),
      ).thenAnswer((_) => Future.value(player2Gp2BetPointsDto));

      final Stream<List<GrandPrixBetPoints>> gpBetPoints1$ =
          repositoryImpl.getGrandPrixBetPointsForPlayersAndGrandPrixes(
        idsOfPlayers: ['p1', 'p2'],
        idsOfGrandPrixes: ['gp1'],
      );
      final Stream<List<GrandPrixBetPoints>> gpBetPoints2$ =
          repositoryImpl.getGrandPrixBetPointsForPlayersAndGrandPrixes(
        idsOfPlayers: ['p1', 'p2'],
        idsOfGrandPrixes: ['gp1', 'gp2'],
      );

      expect(await gpBetPoints1$.first, expectedGpBetPoints1);
      expect(await gpBetPoints2$.first, expectedGpBetPoints2);
      expect(await repositoryImpl.repositoryState$.first, expectedGpBetPoints2);
      verify(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: 'p1',
          grandPrixId: 'gp2',
        ),
      ).called(1);
      verify(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: 'p2',
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(
        () =>
            dbBetPointsService.fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: 'p2',
          grandPrixId: 'gp2',
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
      const GrandPrixBetPointsDto grandPrixBetPointsDto = GrandPrixBetPointsDto(
        id: grandPrixId,
        playerId: playerId,
        grandPrixId: grandPrixId,
        totalPoints: 0.0,
      );
      final GrandPrixBetPoints expectedGrandPrixBetPoints =
          createGrandPrixBetPoints(
        id: grandPrixId,
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
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
