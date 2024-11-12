import 'package:betgrid/ui/screen/bets/cubit/bets_cubit.dart';
import 'package:betgrid/ui/screen/bets/cubit/bets_state.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_v2_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/ui/mock_date_service.dart';
import '../../../mock/use_case/mock_get_grand_prixes_with_points_use_case.dart';
import '../../../mock/use_case/mock_get_player_points_use_case.dart';

void main() {
  final authRepository = MockAuthRepository();
  final getGrandPrixesWithPointsUseCase = MockGetGrandPrixesWithPointsUseCase();
  final getPlayerPointsUseCase = MockGetPlayerPointsUseCase();
  final dateService = MockDateService();

  BetsCubit createCubit() => BetsCubit(
        authRepository,
        getPlayerPointsUseCase,
        getGrandPrixesWithPointsUseCase,
        dateService,
      );

  tearDown(() {
    reset(authRepository);
    reset(getGrandPrixesWithPointsUseCase);
    reset(getPlayerPointsUseCase);
    reset(dateService);
  });

  group(
    'initialize, ',
    () {
      const String loggedUserId = 'u1';
      final DateTime now = DateTime(2024);
      final List<GrandPrixWithPoints> grandPrixesWithPoints = [
        GrandPrixWithPoints(
          grandPrix: GrandPrixV2Creator(seasonGrandPrixId: 'gp1').create(),
          points: 20.0,
        ),
        GrandPrixWithPoints(
          grandPrix: GrandPrixV2Creator(seasonGrandPrixId: 'gp2').create(),
          points: 10.0,
        ),
      ];

      tearDown(() {
        verify(() => authRepository.loggedUserId$).called(1);
      });

      blocTest(
        'should emit state with loggedUserDoesNotExist status if logged user '
        'does not exist',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId(null),
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const BetsState(
            status: BetsStateStatus.loggedUserDoesNotExist,
          ),
        ],
      );

      blocTest(
        'should emit noBets status if logged user has 0 total points and the '
        'list of grand prixes with points is empty',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          getPlayerPointsUseCase.mock();
          dateService.mockGetNow(now: now);
          getGrandPrixesWithPointsUseCase.mock(grandPrixesWithPoints: []);
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const BetsState(
            status: BetsStateStatus.noBets,
            loggedUserId: loggedUserId,
          ),
        ],
        verify: (_) {
          verify(
            () => getPlayerPointsUseCase.call(
              playerId: loggedUserId,
              season: now.year,
            ),
          ).called(1);
          verify(
            () => getGrandPrixesWithPointsUseCase.call(
              playerId: loggedUserId,
              season: now.year,
            ),
          ).called(1);
        },
      );

      blocTest(
        "should emit player's total points and grand prixes with points",
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          getPlayerPointsUseCase.mock(points: 30);
          dateService.mockGetNow(now: now);
          getGrandPrixesWithPointsUseCase.mock(
            grandPrixesWithPoints: grandPrixesWithPoints,
          );
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          BetsState(
            status: BetsStateStatus.completed,
            loggedUserId: loggedUserId,
            totalPoints: 30,
            grandPrixesWithPoints: grandPrixesWithPoints,
          )
        ],
        verify: (_) {
          verify(
            () => getPlayerPointsUseCase.call(
              playerId: loggedUserId,
              season: now.year,
            ),
          ).called(1);
          verify(
            () => getGrandPrixesWithPointsUseCase.call(
              playerId: loggedUserId,
              season: now.year,
            ),
          ).called(1);
        },
      );
    },
  );
}
