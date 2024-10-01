import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/grand_prix_bet_points_creator.dart';
import '../creator/grand_prix_creator.dart';
import '../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../mock/data/repository/mock_grand_prix_repository.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  const String playerId = 'p1';
  late GetGrandPrixesWithPointsUseCase useCase;

  setUp(() {
    useCase = GetGrandPrixesWithPointsUseCase(
      grandPrixRepository,
      grandPrixBetPointsRepository,
    );
  });

  tearDown(() {
    reset(grandPrixRepository);
    reset(grandPrixBetPointsRepository);
  });

  test(
    'list of all grand prixes is null, '
    'should return empty array',
    () {
      grandPrixRepository.mockGetAllGrandPrixes(null);

      final Stream<List<GrandPrixWithPoints>> grandPrixesWithPoints$ =
          useCase(playerId: playerId);

      expect(grandPrixesWithPoints$, emits([]));
    },
  );

  test(
    'list of all grand prixes is empty, '
    'should return empty array',
    () {
      grandPrixRepository.mockGetAllGrandPrixes([]);

      final Stream<List<GrandPrixWithPoints>> grandPrixesWithPoints$ =
          useCase(playerId: playerId);

      expect(grandPrixesWithPoints$, emits([]));
    },
  );

  test(
    'should sort grand prixes by round number in ascending order and '
    'should load total points for each grand prix',
    () {
      final List<GrandPrix> allGrandPrixes = [
        createGrandPrix(id: 'gp1', roundNumber: 3),
        createGrandPrix(id: 'gp2', roundNumber: 1),
        createGrandPrix(id: 'gp3', roundNumber: 2),
      ];
      const double gp1TotalPoints = 10.2;
      const double gp2TotalPoints = 6.5;
      const double gp3TotalPoints = 3.0;
      final List<GrandPrixWithPoints> expectedGrandPrixesWithPoints = [
        GrandPrixWithPoints(
          grandPrix: allGrandPrixes[1],
          points: gp2TotalPoints,
        ),
        GrandPrixWithPoints(
          grandPrix: allGrandPrixes.last,
          points: gp3TotalPoints,
        ),
        GrandPrixWithPoints(
          grandPrix: allGrandPrixes.first,
          points: gp1TotalPoints,
        ),
      ];
      grandPrixRepository.mockGetAllGrandPrixes(allGrandPrixes);
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playerId,
          grandPrixId: 'gp1',
        ),
      ).thenAnswer(
        (_) => Stream.value(
          GrandPrixBetPointsCreator(totalPoints: gp1TotalPoints).createEntity(),
        ),
      );
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playerId,
          grandPrixId: 'gp2',
        ),
      ).thenAnswer(
        (_) => Stream.value(
          GrandPrixBetPointsCreator(totalPoints: gp2TotalPoints).createEntity(),
        ),
      );
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playerId,
          grandPrixId: 'gp3',
        ),
      ).thenAnswer(
        (_) => Stream.value(
          GrandPrixBetPointsCreator(totalPoints: gp3TotalPoints).createEntity(),
        ),
      );

      final Stream<List<GrandPrixWithPoints>> grandPrixesWithPoints$ =
          useCase(playerId: playerId);

      expect(grandPrixesWithPoints$, emits(expectedGrandPrixesWithPoints));
    },
  );
}
