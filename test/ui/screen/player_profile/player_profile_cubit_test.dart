import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/player_profile/cubit/player_profile_cubit.dart';
import 'package:betgrid/ui/screen/player_profile/cubit/player_profile_state.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/player_creator.dart';
import '../../../mock/repository/mock_player_repository.dart';
import '../../../mock/ui/mock_season_cubit.dart';
import '../../../mock/use_case/mock_get_grand_prixes_with_points_use_case.dart';
import '../../../mock/use_case/mock_get_player_points_use_case.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final getPlayerPointsUseCase = MockGetPlayerPointsUseCase();
  final getGrandPrixesWithPointsUseCase = MockGetGrandPrixesWithPointsUseCase();
  final seasonCubit = MockSeasonCubit();
  const String playerId = 'p1';

  PlayerProfileCubit createCubit() => PlayerProfileCubit(
    playerRepository,
    getPlayerPointsUseCase,
    getGrandPrixesWithPointsUseCase,
    seasonCubit,
    playerId,
  );

  group('initialize, ', () {
    const int season = 2024;
    final Player player = const PlayerCreator(id: playerId).create();
    const double playerPoints = 10.2;
    final List<GrandPrixWithPoints> grandPrixesWithPoints = [
      GrandPrixWithPoints(
        seasonGrandPrixId: 'gp1',
        name: 'gp1',
        countryAlpha2Code: 'FR',
        roundNumber: 1,
        startDate: DateTime(season, 1, 1),
        endDate: DateTime(season, 1, 1),
        points: 10.2,
      ),
      GrandPrixWithPoints(
        seasonGrandPrixId: 'gp2',
        name: 'gp2',
        countryAlpha2Code: 'FR',
        roundNumber: 2,
        startDate: DateTime(season, 1, 1),
        endDate: DateTime(season, 1, 1),
        points: 10.2,
      ),
    ];

    blocTest(
      'should load and emit player data, total points and grand prixes with '
      'points',
      build: () => createCubit(),
      setUp: () {
        playerRepository.mockGetById(player: player);
        getPlayerPointsUseCase.mock(points: playerPoints);
        seasonCubit.mockState(expectedState: season);
        getGrandPrixesWithPointsUseCase.mock(
          grandPrixesWithPoints: grandPrixesWithPoints,
        );
      },
      act: (cubit) => cubit.initialize(),
      expect:
          () => [
            PlayerProfileState(
              status: PlayerProfileStateStatus.completed,
              player: player,
              season: season,
              totalPoints: playerPoints,
              grandPrixesWithPoints: grandPrixesWithPoints,
            ),
          ],
      verify: (_) {
        verify(() => playerRepository.getById(playerId)).called(1);
        verify(
          () => getPlayerPointsUseCase.call(playerId: playerId, season: season),
        ).called(1);
        verify(
          () => getGrandPrixesWithPointsUseCase.call(
            playerId: playerId,
            season: season,
          ),
        ).called(1);
      },
    );
  });
}
