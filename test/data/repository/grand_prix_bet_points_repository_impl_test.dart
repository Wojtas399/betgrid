import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_impl.dart';
import 'package:betgrid/firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import 'package:betgrid/firebase/service/firebase_grand_prix_bet_points_service.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/data/repository/mock_firebase_grand_prix_bet_points_service.dart';

void main() {
  final dbBetPointsService = MockFirebaseGrandPrixBetPointsService();
  late GrandPrixBetPointsRepositoryImpl repositoryImpl;

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseGrandPrixBetPointsService>(
      () => dbBetPointsService,
    );
  });

  setUp(() {
    repositoryImpl = GrandPrixBetPointsRepositoryImpl();
  });

  tearDown(() {
    reset(dbBetPointsService);
  });

  test(
    'getPointsForPlayerByGrandPrixId, '
    'grand prix bet points exists in repository state, '
    'should emit grand prix bet points from repository state',
    () async {
      const String playerId = 'p1';
      const String grandPrixId = 'gp2';
      const List<GrandPrixBetPoints> existingEntities = [
        GrandPrixBetPoints(
          id: grandPrixId,
          playerId: playerId,
          grandPrixId: 'gp1',
        ),
        GrandPrixBetPoints(
          id: 'gp3',
          playerId: 'p2',
          grandPrixId: grandPrixId,
        ),
        GrandPrixBetPoints(
          id: 'gp1',
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
        GrandPrixBetPoints(
          id: 'gp4',
          playerId: 'p2',
          grandPrixId: 'gp1',
        ),
      ];
      repositoryImpl = GrandPrixBetPointsRepositoryImpl(
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
      );
      const GrandPrixBetPoints expectedGrandPrixBetPoints = GrandPrixBetPoints(
        id: grandPrixId,
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      const List<GrandPrixBetPoints> existingEntities = [
        GrandPrixBetPoints(
          id: 'gp1',
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
        GrandPrixBetPoints(
          id: 'gp3',
          playerId: 'p2',
          grandPrixId: grandPrixId,
        ),
      ];
      dbBetPointsService.mockLoadGrandPrixBetPointsByPlayerIdAndGrandPrixId(
        grandPrixBetPointsDto: grandPrixBetPointsDto,
      );
      repositoryImpl = GrandPrixBetPointsRepositoryImpl(
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
