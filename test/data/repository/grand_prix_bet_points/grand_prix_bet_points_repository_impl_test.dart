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
    'grand prix bet points exists in repository state, '
    'should emit grand prix bet points from repository state',
    () async {
      const String playerId = 'p1';
      const String grandPrixId = 'gp2';
      final List<GrandPrixBetPoints> existingEntities = [
        createGrandPrixBetPoints(
          id: grandPrixId,
          playerId: playerId,
          grandPrixId: 'gp1',
        ),
        createGrandPrixBetPoints(
          id: 'gp3',
          playerId: 'p2',
          grandPrixId: grandPrixId,
        ),
        createGrandPrixBetPoints(
          id: 'gp1',
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
        createGrandPrixBetPoints(
          id: 'gp4',
          playerId: 'p2',
          grandPrixId: 'gp1',
        ),
      ];
      final repositoryImpl = GrandPrixBetPointsRepositoryImpl(
        firebaseGrandPrixBetPointsService: dbBetPointsService,
        initialData: existingEntities,
      );

      final Stream<GrandPrixBetPoints?> points$ =
          repositoryImpl.getPointsForPlayerByGrandPrixId(
        playerId: playerId,
        grandPrixId: grandPrixId,
      );

      expect(points$, emits(existingEntities[2]));
    },
  );

  test(
    'getPointsForPlayerByGrandPrixId, '
    'grand prix bet points do not exist in repository state, '
    'should load grand prix bet points from db, add it to repository state and emit it',
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
      final List<GrandPrixBetPoints> existingEntities = [
        createGrandPrixBetPoints(
          id: 'gp1',
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
        createGrandPrixBetPoints(
          id: 'gp3',
          playerId: 'p2',
          grandPrixId: grandPrixId,
        ),
      ];
      dbBetPointsService.mockLoadGrandPrixBetPointsByPlayerIdAndGrandPrixId(
        grandPrixBetPointsDto: grandPrixBetPointsDto,
      );
      final repositoryImpl = GrandPrixBetPointsRepositoryImpl(
        firebaseGrandPrixBetPointsService: dbBetPointsService,
        initialData: existingEntities,
      );

      final Stream<GrandPrixBetPoints?> points$ =
          repositoryImpl.getPointsForPlayerByGrandPrixId(
        playerId: playerId,
        grandPrixId: grandPrixId,
      );

      expect(await points$.first, expectedGrandPrixBetPoints);
      expect(
        repositoryImpl.repositoryState$,
        emits([
          ...existingEntities,
          expectedGrandPrixBetPoints,
        ]),
      );
      verify(
        () => dbBetPointsService.loadGrandPrixBetPointsByPlayerIdAndGrandPrixId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );
}
