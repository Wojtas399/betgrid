import 'package:betgrid/model/grand_prix_v2.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/grand_prix_bet_points_creator.dart';
import '../creator/grand_prix_v2_creator.dart';
import '../creator/season_grand_prix_creator.dart';
import '../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../mock/data/repository/mock_season_grand_prix_repository.dart';
import '../mock/use_case/mock_get_grand_prix_based_on_season_grand_prix_use_case.dart';

void main() {
  final seasonGrandPrixRepository = MockSeasonGrandPrixRepository();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  final getGrandPrixBasedOnSeasonGrandPrixUseCase =
      MockGetGrandPrixBasedOnSeasonGrandPrixUseCase();
  late GetGrandPrixesWithPointsUseCase useCase;
  const String playerId = 'p1';
  const int season = 2024;

  setUp(() {
    useCase = GetGrandPrixesWithPointsUseCase(
      seasonGrandPrixRepository,
      grandPrixBetPointsRepository,
      getGrandPrixBasedOnSeasonGrandPrixUseCase,
    );
  });

  tearDown(() {
    reset(seasonGrandPrixRepository);
    reset(grandPrixBetPointsRepository);
  });

  test(
    'should return empty array if list of all season grand prixes is empty',
    () {
      seasonGrandPrixRepository.mockGetAllSeasonGrandPrixesFromSeason(
        expectedSeasonGrandPrixes: [],
      );

      final Stream<List<GrandPrixWithPoints>> grandPrixesWithPoints$ = useCase(
        playerId: playerId,
        season: season,
      );

      expect(grandPrixesWithPoints$, emits([]));
    },
  );

  test(
    'should sort season grand prixes by round number in ascending order, '
    'should convert them to GrandPrix model and should load total points for '
    'each of them',
    () {
      final List<SeasonGrandPrix> allSeasonGrandPrixes = [
        SeasonGrandPrixCreator(id: 'sgp1', roundNumber: 3).createEntity(),
        SeasonGrandPrixCreator(id: 'sgp2', roundNumber: 1).createEntity(),
        SeasonGrandPrixCreator(id: 'sgp3', roundNumber: 2).createEntity(),
      ];
      final List<GrandPrixV2> allGrandPrixes = [
        GrandPrixV2Creator(seasonGrandPrixId: 'sgp1').create(),
        GrandPrixV2Creator(seasonGrandPrixId: 'sgp2').create(),
      ];
      const double sgp1TotalPoints = 10.2;
      const double sgp2TotalPoints = 6.5;
      const double sgp3TotalPoints = 3;
      final List<GrandPrixWithPoints> expectedGrandPrixesWithPoints = [
        GrandPrixWithPoints(
          grandPrix: allGrandPrixes[1],
          points: sgp2TotalPoints,
        ),
        GrandPrixWithPoints(
          grandPrix: allGrandPrixes.first,
          points: sgp1TotalPoints,
        ),
      ];
      seasonGrandPrixRepository.mockGetAllSeasonGrandPrixesFromSeason(
        expectedSeasonGrandPrixes: allSeasonGrandPrixes,
      );
      when(
        () => getGrandPrixBasedOnSeasonGrandPrixUseCase.call(
          allSeasonGrandPrixes.first,
        ),
      ).thenAnswer((_) => Stream.value(allGrandPrixes.first));
      when(
        () => getGrandPrixBasedOnSeasonGrandPrixUseCase.call(
          allSeasonGrandPrixes[1],
        ),
      ).thenAnswer((_) => Stream.value(allGrandPrixes[1]));
      when(
        () => getGrandPrixBasedOnSeasonGrandPrixUseCase.call(
          allSeasonGrandPrixes.last,
        ),
      ).thenAnswer((_) => Stream.value(null));
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
          playerId: playerId,
          seasonGrandPrixId: allSeasonGrandPrixes.first.id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          const GrandPrixBetPointsCreator(
            totalPoints: sgp1TotalPoints,
          ).createEntity(),
        ),
      );
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
          playerId: playerId,
          seasonGrandPrixId: allSeasonGrandPrixes[1].id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          const GrandPrixBetPointsCreator(
            totalPoints: sgp2TotalPoints,
          ).createEntity(),
        ),
      );
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
          playerId: playerId,
          seasonGrandPrixId: allSeasonGrandPrixes.last.id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          const GrandPrixBetPointsCreator(
            totalPoints: sgp3TotalPoints,
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
