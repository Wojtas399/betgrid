import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/player_profile/cubit/player_profile_cubit.dart';
import 'package:betgrid/ui/screen/player_profile/cubit/player_profile_state.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../mock/data/repository/mock_player_repository.dart';
import '../../../mock/ui/mock_date_service.dart';
import '../../../mock/use_case/mock_get_grand_prixes_with_points_use_case.dart';
import '../../../mock/use_case/mock_get_player_points_use_case.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final getPlayerPointsUseCase = MockGetPlayerPointsUseCase();
  final getGrandPrixesWithPointsUseCase = MockGetGrandPrixesWithPointsUseCase();
  final dateService = MockDateService();

  PlayerProfileCubit createCubit() => PlayerProfileCubit(
        playerRepository,
        getPlayerPointsUseCase,
        getGrandPrixesWithPointsUseCase,
        dateService,
      );

  group(
    'initialize, ',
    () {
      const String playerId = 'p1';
      final DateTime now = DateTime(2024);
      final Player player = const PlayerCreator(id: playerId).createEntity();
      const double playerPoints = 10.2;
      final List<GrandPrixWithPoints> grandPrixesWithPoints = [
        GrandPrixWithPoints(
          grandPrix: GrandPrixCreator(id: 'gp1').createEntity(),
        ),
        GrandPrixWithPoints(
          grandPrix: GrandPrixCreator(id: 'gp2').createEntity(),
        ),
      ];

      blocTest(
        'should load and emit player data, total points and grand prixes with '
        'points',
        build: () => createCubit(),
        setUp: () {
          playerRepository.mockGetPlayerById(player: player);
          getPlayerPointsUseCase.mock(points: playerPoints);
          dateService.mockGetNow(now: now);
          getGrandPrixesWithPointsUseCase.mock(
            grandPrixesWithPoints: grandPrixesWithPoints,
          );
        },
        act: (cubit) async => await cubit.initialize(playerId: playerId),
        expect: () => [
          PlayerProfileState(
            status: PlayerProfileStateStatus.completed,
            player: player,
            totalPoints: playerPoints,
            grandPrixesWithPoints: grandPrixesWithPoints,
          ),
        ],
        verify: (_) {
          verify(
            () => playerRepository.getPlayerById(playerId: playerId),
          ).called(1);
          verify(
            () => getPlayerPointsUseCase.call(
              playerId: playerId,
              season: now.year,
            ),
          ).called(1);
          verify(
            () => getGrandPrixesWithPointsUseCase.call(
              playerId: playerId,
              season: now.year,
            ),
          ).called(1);
        },
      );
    },
  );
}
