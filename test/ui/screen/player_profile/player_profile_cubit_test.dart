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
        player: PlayerCreator(id: 'p1').createEntity(),
      );
      getPlayerPointsUseCase.mock(points: 10.2);
      getGrandPrixesWithPointsUseCase.mock(
        grandPrixesWithPoints: [
          GrandPrixWithPoints(
            grandPrix: GrandPrixCreator(id: 'gp1').createEntity(),
          ),
          GrandPrixWithPoints(
            grandPrix: GrandPrixCreator(id: 'gp2').createEntity(),
          ),
        ],
      );
    },
    act: (cubit) async => await cubit.initialize(playerId: 'p1'),
    expect: () => [
      PlayerProfileState(
        status: PlayerProfileStateStatus.completed,
        player: PlayerCreator(id: 'p1').createEntity(),
        totalPoints: 10.2,
        grandPrixesWithPoints: [
          GrandPrixWithPoints(
            grandPrix: GrandPrixCreator(id: 'gp1').createEntity(),
          ),
          GrandPrixWithPoints(
            grandPrix: GrandPrixCreator(id: 'gp2').createEntity(),
          ),
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
