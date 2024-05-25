import 'package:betgrid/ui/screen/bets/cubit/bets_cubit.dart';
import 'package:betgrid/ui/screen/bets/cubit/bets_state.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/use_case/mock_get_grand_prixes_with_points_use_case.dart';
import '../../../mock/use_case/mock_get_player_points_use_case.dart';

void main() {
  final authRepository = MockAuthRepository();
  final getGrandPrixesWithPointsUseCase = MockGetGrandPrixesWithPointsUseCase();
  final getPlayerPointsUseCase = MockGetPlayerPointsUseCase();

  BetsCubit createCubit() => BetsCubit(
        authRepository,
        getPlayerPointsUseCase,
        getGrandPrixesWithPointsUseCase,
      );

  tearDown(() {
    reset(authRepository);
    reset(getGrandPrixesWithPointsUseCase);
    reset(getPlayerPointsUseCase);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should emit state with loggedUserDoesNotExist status',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(null),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const BetsState(
        status: BetsStateStatus.loggedUserDoesNotExist,
      ),
    ],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    "should emit player's total points and grand prixes with points",
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      getPlayerPointsUseCase.mock(points: 30);
      getGrandPrixesWithPointsUseCase.mock(
        grandPrixesWithPoints: [
          GrandPrixWithPoints(
            grandPrix: createGrandPrix(id: 'gp1'),
            points: 20.0,
          ),
          GrandPrixWithPoints(
            grandPrix: createGrandPrix(id: 'gp2'),
            points: 10.0,
          ),
        ],
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      BetsState(
        status: BetsStateStatus.completed,
        loggedUserId: 'u1',
        totalPoints: 30,
        grandPrixesWithPoints: [
          GrandPrixWithPoints(
            grandPrix: createGrandPrix(id: 'gp1'),
            points: 20.0,
          ),
          GrandPrixWithPoints(
            grandPrix: createGrandPrix(id: 'gp2'),
            points: 10.0,
          ),
        ],
      )
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => getPlayerPointsUseCase.call(playerId: 'u1')).called(1);
      verify(
        () => getGrandPrixesWithPointsUseCase.call(playerId: 'u1'),
      ).called(1);
    },
  );
}
