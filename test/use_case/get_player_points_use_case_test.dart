import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/use_case/get_player_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/season_grand_prix_bet_points_creator.dart';
import '../creator/season_grand_prix_creator.dart';
import '../mock/repository/mock_season_grand_prix_bet_points_repository.dart';
import '../mock/repository/mock_season_grand_prix_repository.dart';

void main() {
  final seasonGrandPrixRepository = MockSeasonGrandPrixRepository();
  final seasonGrandPrixBetPointsRepository =
      MockSeasonGrandPrixBetPointsRepository();
  late GetPlayerPointsUseCase useCase;
  const String playerId = 'p1';
  const int season = 2024;

  setUp(() {
    useCase = GetPlayerPointsUseCase(
      seasonGrandPrixRepository,
      seasonGrandPrixBetPointsRepository,
    );
  });

  tearDown(() {
    reset(seasonGrandPrixRepository);
    reset(seasonGrandPrixBetPointsRepository);
  });

  test(
    'should return null if list of all season grand prixes is null',
    () {
      seasonGrandPrixRepository.mockGetAllFromSeason(
        expectedSeasonGrandPrixes: [],
      );

      final Stream<double?> playerPoints$ = useCase(
        playerId: playerId,
        season: season,
      );

      expect(
        playerPoints$,
        emits(null),
      );
    },
  );

  test(
    'should sum points of each grand prix',
    () async {
      const double sgp1Points = 10.0;
      const double sgp2Points = 7.5;
      const double sgp3Points = 12.25;
      const double expectedPoints = sgp1Points + sgp2Points + sgp3Points;
      final List<SeasonGrandPrix> seasonGrandPrixes = [
        SeasonGrandPrixCreator(id: 'sgp1').create(),
        SeasonGrandPrixCreator(id: 'sgp2').create(),
        SeasonGrandPrixCreator(id: 'sgp3').create(),
      ];
      seasonGrandPrixRepository.mockGetAllFromSeason(
        expectedSeasonGrandPrixes: seasonGrandPrixes,
      );
      when(
        () => seasonGrandPrixBetPointsRepository.getSeasonGrandPrixBetPoints(
          playerId: playerId,
          season: season,
          seasonGrandPrixId: seasonGrandPrixes.first.id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          const SeasonGrandPrixBetPointsCreator(
            totalPoints: sgp1Points,
          ).create(),
        ),
      );
      when(
        () => seasonGrandPrixBetPointsRepository.getSeasonGrandPrixBetPoints(
          playerId: playerId,
          season: season,
          seasonGrandPrixId: seasonGrandPrixes[1].id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          const SeasonGrandPrixBetPointsCreator(
            totalPoints: sgp2Points,
          ).create(),
        ),
      );
      when(
        () => seasonGrandPrixBetPointsRepository.getSeasonGrandPrixBetPoints(
          playerId: playerId,
          season: season,
          seasonGrandPrixId: seasonGrandPrixes.last.id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          const SeasonGrandPrixBetPointsCreator(
            totalPoints: sgp3Points,
          ).create(),
        ),
      );

      final Stream<double?> playerPoints$ = useCase(
        playerId: playerId,
        season: season,
      );

      expect(playerPoints$, emits(expectedPoints));
    },
  );
}
