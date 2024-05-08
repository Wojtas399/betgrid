import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_impl.dart';
import 'package:betgrid/firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../mock/data/repository/mock_firebase_grand_prix_bet_points_service.dart';

void main() {
  final dbBetPointsService = MockFirebaseGrandPrixBetPointsService();

  test(
    'getPointsForPlayerByGrandPrixId, '
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
      final repositoryImpl = GrandPrixBetPointsRepositoryImpl(
        dbBetPointsService,
      );

      final Stream<GrandPrixBetPoints?> points1$ =
          repositoryImpl.getPointsForPlayerByGrandPrixId(
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      final Stream<GrandPrixBetPoints?> points2$ =
          repositoryImpl.getPointsForPlayerByGrandPrixId(
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
