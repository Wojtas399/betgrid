import 'package:betgrid/model/grand_prix_basic_info.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/grand_prix_basic_info_creator.dart';
import '../creator/grand_prix_bet_points_creator.dart';
import '../creator/season_grand_prix_creator.dart';
import '../mock/data/repository/mock_grand_prix_basic_info_repository.dart';
import '../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../mock/data/repository/mock_season_grand_prix_repository.dart';

void main() {
  final seasonGrandPrixRepository = MockSeasonGrandPrixRepository();
  final grandPrixBasicInfoRepository = MockGrandPrixBasicInfoRepository();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  late GetGrandPrixesWithPointsUseCase useCase;
  const String playerId = 'p1';
  const int season = 2024;

  setUp(() {
    useCase = GetGrandPrixesWithPointsUseCase(
      seasonGrandPrixRepository,
      grandPrixBasicInfoRepository,
      grandPrixBetPointsRepository,
    );
  });

  tearDown(() {
    reset(seasonGrandPrixRepository);
    reset(grandPrixBasicInfoRepository);
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
      final List<SeasonGrandPrix> grandPrixesFromSeason = [
        SeasonGrandPrixCreator(
          id: 'sgp1',
          roundNumber: 3,
          grandPrixId: 'gp1',
        ).createEntity(),
        SeasonGrandPrixCreator(
          id: 'sgp2',
          roundNumber: 1,
          grandPrixId: 'gp2',
        ).createEntity(),
        SeasonGrandPrixCreator(
          id: 'sgp3',
          roundNumber: 2,
          grandPrixId: 'gp3',
        ).createEntity(),
      ];
      final List<GrandPrixBasicInfo> allGrandPrixes = [
        const GrandPrixBasicInfoCreator(
          name: 'gp1',
          countryAlpha2Code: 'FR',
        ).createEntity(),
        const GrandPrixBasicInfoCreator(
          name: 'gp2',
          countryAlpha2Code: 'FR',
        ).createEntity(),
      ];
      const double sgp1TotalPoints = 10.2;
      const double sgp2TotalPoints = 6.5;
      const double sgp3TotalPoints = 3;
      final List<GrandPrixWithPoints> expectedGrandPrixesWithPoints = [
        GrandPrixWithPoints(
          seasonGrandPrixId: grandPrixesFromSeason.first.id,
          name: allGrandPrixes.first.name,
          countryAlpha2Code: allGrandPrixes.first.countryAlpha2Code,
          roundNumber: grandPrixesFromSeason.first.roundNumber,
          startDate: grandPrixesFromSeason.first.startDate,
          endDate: grandPrixesFromSeason.first.endDate,
          points: sgp1TotalPoints,
        ),
        GrandPrixWithPoints(
          seasonGrandPrixId: grandPrixesFromSeason[1].id,
          name: allGrandPrixes[1].name,
          countryAlpha2Code: allGrandPrixes[1].countryAlpha2Code,
          roundNumber: grandPrixesFromSeason[1].roundNumber,
          startDate: grandPrixesFromSeason[1].startDate,
          endDate: grandPrixesFromSeason[1].endDate,
          points: sgp2TotalPoints,
        ),
      ];
      seasonGrandPrixRepository.mockGetAllSeasonGrandPrixesFromSeason(
        expectedSeasonGrandPrixes: grandPrixesFromSeason,
      );
      when(
        () => grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(
          grandPrixesFromSeason.first.grandPrixId,
        ),
      ).thenAnswer((_) => Stream.value(allGrandPrixes.first));
      when(
        () => grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(
          grandPrixesFromSeason[1].grandPrixId,
        ),
      ).thenAnswer((_) => Stream.value(allGrandPrixes[1]));
      when(
        () => grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(
          grandPrixesFromSeason.last.grandPrixId,
        ),
      ).thenAnswer((_) => Stream.value(null));
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
          playerId: playerId,
          seasonGrandPrixId: grandPrixesFromSeason.first.id,
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
          seasonGrandPrixId: grandPrixesFromSeason[1].id,
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
          seasonGrandPrixId: grandPrixesFromSeason.last.id,
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
