import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../lib/use_case/get_grand_prixes_bet_points_use_case.dart';
import '../creator/grand_prix_bet_points_creator.dart';
import '../mock/data/repository/mock_grand_prix_bet_points_repository.dart';

void main() {
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  late GetGrandPrixesBetPointsUseCase useCase;

  setUp(() {
    useCase = GetGrandPrixesBetPointsUseCase(
      grandPrixBetPointsRepository,
    );
  });

  tearDown(() {
    reset(grandPrixBetPointsRepository);
  });

  test(
    "List of players' ids is empty, "
    'should emit empty list',
    () {
      final Stream<List<GrandPrixBetPoints>> gpsBetPoints$ = useCase(
        playersIds: [],
        grandPrixesIds: ['gp1', 'gp2'],
      );

      expect(gpsBetPoints$, emits([]));
    },
  );

  test(
    "List of grand prixes' ids is empty, "
    'should emit empty list',
    () {
      final Stream<List<GrandPrixBetPoints>> gpsBetPoints$ = useCase(
        playersIds: ['p1', 'p2'],
        grandPrixesIds: [],
      );

      expect(gpsBetPoints$, emits([]));
    },
  );

  test(
    'Should load bet points for each player and grand prix',
    () {
      const List<String> playersIds = ['p1', 'p2'];
      const List<String> grandPrixesIds = ['gp1', 'gp2'];
      final GrandPrixBetPoints p1Gp1BetPoints = createGrandPrixBetPoints(
        id: 'gpbp1',
        playerId: playersIds[0],
        grandPrixId: grandPrixesIds[0],
      );
      final GrandPrixBetPoints p1Gp2BetPoints = createGrandPrixBetPoints(
        id: 'gpbp2',
        playerId: playersIds[0],
        grandPrixId: grandPrixesIds[1],
      );
      final GrandPrixBetPoints p2Gp1BetPoints = createGrandPrixBetPoints(
        id: 'gpbp3',
        playerId: playersIds[1],
        grandPrixId: grandPrixesIds[0],
      );
      final List<GrandPrixBetPoints> expectedGpsBetPoints = [
        p1Gp1BetPoints,
        p1Gp2BetPoints,
        p2Gp1BetPoints,
      ];
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playersIds[0],
          grandPrixId: grandPrixesIds[0],
        ),
      ).thenAnswer((_) => Stream.value(p1Gp1BetPoints));
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playersIds[0],
          grandPrixId: grandPrixesIds[1],
        ),
      ).thenAnswer((_) => Stream.value(p1Gp2BetPoints));
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playersIds[1],
          grandPrixId: grandPrixesIds[0],
        ),
      ).thenAnswer((_) => Stream.value(p2Gp1BetPoints));
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playersIds[1],
          grandPrixId: grandPrixesIds[1],
        ),
      ).thenAnswer((_) => Stream.value(null));

      final Stream<List<GrandPrixBetPoints>> gpsBetPoints$ = useCase(
        playersIds: playersIds,
        grandPrixesIds: grandPrixesIds,
      );

      expect(gpsBetPoints$, emits(expectedGpsBetPoints));
    },
  );
}
