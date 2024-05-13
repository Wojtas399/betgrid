import 'package:betgrid/ui/screen/player_profile/cubit/player_profile_cubit.dart';
import 'package:betgrid/ui/screen/player_profile/cubit/player_profile_state.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../mock/data/repository/mock_player_repository.dart';
import '../../../mock/use_case/mock_get_grand_prixes_with_points_use_case.dart';
import '../../../mock/use_case/mock_get_player_points_use_case.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final getPlayerPointsUseCase = MockGetPlayerPointsUseCase();
  final getGrandPrixesWithPointsUseCase = MockGetGrandPrixesWithPointsUseCase();

  PlayerProfileCubit createCubit() => PlayerProfileCubit(
        playerRepository,
        getPlayerPointsUseCase,
        getGrandPrixesWithPointsUseCase,
      );

  blocTest(
    'initialize, '
    'should load and emit player data, total points and grand prixes with points',
    build: () => createCubit(),
    setUp: () {
      playerRepository.mockGetPlayerById(
        player: createPlayer(id: 'p1'),
      );
      getPlayerPointsUseCase.mock(points: 10.2);
      getGrandPrixesWithPointsUseCase.mock(
        grandPrixesWithPoints: [
          GrandPrixWithPoints(grandPrix: createGrandPrix(id: 'gp1')),
          GrandPrixWithPoints(grandPrix: createGrandPrix(id: 'gp2')),
        ],
      );
    },
    act: (cubit) async => await cubit.initialize(playerId: 'p1'),
    expect: () => [
      PlayerProfileState(
        status: PlayerProfileStateStatus.completed,
        player: createPlayer(id: 'p1'),
        totalPoints: 10.2,
        grandPrixesWithPoints: [
          GrandPrixWithPoints(grandPrix: createGrandPrix(id: 'gp1')),
          GrandPrixWithPoints(grandPrix: createGrandPrix(id: 'gp2')),
        ],
      ),
    ],
    verify: (_) {
      verify(() => playerRepository.getPlayerById(playerId: 'p1')).called(1);
      verify(() => getPlayerPointsUseCase.call(playerId: 'p1')).called(1);
      verify(
        () => getGrandPrixesWithPointsUseCase.call(playerId: 'p1'),
      ).called(1);
    },
  );
}
