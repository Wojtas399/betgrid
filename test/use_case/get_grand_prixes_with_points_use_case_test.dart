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
  late GetGrandPrixesWithPointsUseCase useCase;
  const String playerId = 'p1';
  const int season = 2024;

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
    'should return empty array if list of all grand prixes is null',
    () {
      grandPrixRepository.mockGetAllGrandPrixesFromSeason();

      final Stream<List<GrandPrixWithPoints>> grandPrixesWithPoints$ = useCase(
        playerId: playerId,
        season: season,
      );

      expect(grandPrixesWithPoints$, emits([]));
    },
  );

  test(
    'should return empty array if list of all grand prixes is empty',
    () {
      grandPrixRepository.mockGetAllGrandPrixesFromSeason(
        expectedGrandPrixes: [],
      );

      final Stream<List<GrandPrixWithPoints>> grandPrixesWithPoints$ = useCase(
        playerId: playerId,
        season: season,
      );

      expect(grandPrixesWithPoints$, emits([]));
    },
  );

  test(
    'should sort grand prixes by round number in ascending order and should '
    'load total points for each grand prix',
    () {
      final List<GrandPrix> allGrandPrixes = [
        GrandPrixCreator(id: 'gp1', roundNumber: 3).createEntity(),
        GrandPrixCreator(id: 'gp2', roundNumber: 1).createEntity(),
        GrandPrixCreator(id: 'gp3', roundNumber: 2).createEntity(),
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
      grandPrixRepository.mockGetAllGrandPrixesFromSeason(
        expectedGrandPrixes: allGrandPrixes,
      );
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playerId,
          grandPrixId: allGrandPrixes.first.id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          const GrandPrixBetPointsCreator(
            totalPoints: gp1TotalPoints,
          ).createEntity(),
        ),
      );
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playerId,
          grandPrixId: allGrandPrixes[1].id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          const GrandPrixBetPointsCreator(
            totalPoints: gp2TotalPoints,
          ).createEntity(),
        ),
      );
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playerId,
          grandPrixId: allGrandPrixes.last.id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          const GrandPrixBetPointsCreator(
            totalPoints: gp3TotalPoints,
          ).createEntity(),
        ),
      );

      final Stream<List<GrandPrixWithPoints>> grandPrixesWithPoints$ = useCase(
        playerId: playerId,
        season: season,
      );

      expect(grandPrixesWithPoints$, emits(expectedGrandPrixesWithPoints));
    },
  );
}
