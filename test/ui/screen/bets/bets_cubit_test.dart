import 'package:betgrid/ui/screen/bets/cubit/bets_cubit.dart';
import 'package:betgrid/ui/screen/bets/cubit/bets_state.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_v2_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/ui/mock_date_service.dart';
import '../../../mock/ui/screen/mock_bets_gp_status_service.dart';
import '../../../mock/use_case/mock_get_grand_prixes_with_points_use_case.dart';
import '../../../mock/use_case/mock_get_player_points_use_case.dart';

void main() {
  final authRepository = MockAuthRepository();
  final getGrandPrixesWithPointsUseCase = MockGetGrandPrixesWithPointsUseCase();
  final getPlayerPointsUseCase = MockGetPlayerPointsUseCase();
  final betsGpStatusService = MockBetsGpStatusService();
  final dateService = MockDateService();

  BetsCubit createCubit() => BetsCubit(
        authRepository,
        getPlayerPointsUseCase,
        getGrandPrixesWithPointsUseCase,
        betsGpStatusService,
        dateService,
      );

  tearDown(() {
    reset(authRepository);
    reset(getGrandPrixesWithPointsUseCase);
    reset(getPlayerPointsUseCase);
    reset(betsGpStatusService);
    reset(dateService);
  });

  group(
    'initialize, ',
    () {
      const String loggedUserId = 'u1';
      final DateTime now = DateTime(2025, 1, 1);
      final List<GrandPrixWithPoints> grandPrixesWithPoints = [
        GrandPrixWithPoints(
          grandPrix: GrandPrixV2Creator(
            seasonGrandPrixId: 'gp4',
            roundNumber: 4,
            startDate: DateTime(2025, 4, 1),
            endDate: DateTime(2025, 4, 2),
          ).create(),
          points: 10.0,
        ),
        GrandPrixWithPoints(
          grandPrix: GrandPrixV2Creator(
            seasonGrandPrixId: 'gp1',
            roundNumber: 1,
            startDate: DateTime(2025, 1, 1),
            endDate: DateTime(2025, 1, 2),
          ).create(),
          points: 20.0,
        ),
        GrandPrixWithPoints(
          grandPrix: GrandPrixV2Creator(
            seasonGrandPrixId: 'gp3',
            roundNumber: 3,
            startDate: DateTime(2025, 3, 1),
            endDate: DateTime(2025, 3, 2),
          ).create(),
          points: 30.0,
        ),
        GrandPrixWithPoints(
          grandPrix: GrandPrixV2Creator(
            seasonGrandPrixId: 'gp2',
            roundNumber: 2,
            startDate: DateTime(2025, 2, 1),
            endDate: DateTime(2025, 2, 2),
          ).create(),
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
          getGrandPrixesWithPointsUseCase.mock(grandPrixesWithPoints: []);
          dateService.mockGetNowStream(expectedNow: now);
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
              season: 2025,
            ),
          ).called(1);
          verify(
            () => getGrandPrixesWithPointsUseCase.call(
              playerId: loggedUserId,
              season: 2025,
            ),
          ).called(1);
          verify(dateService.getNowStream).called(1);
        },
      );

      blocTest(
        'should define status for each grand prix and should find first gp '
        'after ongoing gp and should set GrandPrixStatusNext for it with '
        'calculated duration to start',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          getPlayerPointsUseCase.mock(points: 30);
          getGrandPrixesWithPointsUseCase.mock(
            grandPrixesWithPoints: grandPrixesWithPoints,
          );
          dateService.mockGetNowStream(expectedNow: now);
          when(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[0].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[0].grandPrix.endDate,
              now: now,
            ),
          ).thenReturn(const GrandPrixStatusUpcoming());
          when(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[1].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[1].grandPrix.endDate,
              now: now,
            ),
          ).thenReturn(const GrandPrixStatusFinished());
          when(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[2].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[2].grandPrix.endDate,
              now: now,
            ),
          ).thenReturn(const GrandPrixStatusUpcoming());
          when(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints.last.grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints.last.grandPrix.endDate,
              now: now,
            ),
          ).thenReturn(const GrandPrixStatusOngoing());
          dateService.mockGetDurationToDateFromNow(
            duration: const Duration(days: 1, minutes: 34),
          );
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          BetsState(
            status: BetsStateStatus.completed,
            loggedUserId: loggedUserId,
            totalPoints: 30,
            grandPrixItems: [
              GrandPrixItemParams(
                status: const GrandPrixStatusUpcoming(),
                grandPrix: grandPrixesWithPoints[0].grandPrix,
                betPoints: grandPrixesWithPoints[0].points,
              ),
              GrandPrixItemParams(
                status: const GrandPrixStatusFinished(),
                grandPrix: grandPrixesWithPoints[1].grandPrix,
                betPoints: grandPrixesWithPoints[1].points,
              ),
              GrandPrixItemParams(
                status: const GrandPrixStatusNext(
                  durationToStart: Duration(days: 1, minutes: 34),
                ),
                grandPrix: grandPrixesWithPoints[2].grandPrix,
                betPoints: grandPrixesWithPoints[2].points,
              ),
              GrandPrixItemParams(
                status: const GrandPrixStatusOngoing(),
                grandPrix: grandPrixesWithPoints.last.grandPrix,
                betPoints: grandPrixesWithPoints.last.points,
              ),
            ],
          )
        ],
        verify: (_) {
          verify(
            () => getPlayerPointsUseCase.call(
              playerId: loggedUserId,
              season: 2025,
            ),
          ).called(1);
          verify(
            () => getGrandPrixesWithPointsUseCase.call(
              playerId: loggedUserId,
              season: 2025,
            ),
          ).called(1);
          verify(dateService.getNowStream).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[0].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[0].grandPrix.endDate,
              now: now,
            ),
          ).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[1].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[1].grandPrix.endDate,
              now: now,
            ),
          ).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[2].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[2].grandPrix.endDate,
              now: now,
            ),
          ).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints.last.grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints.last.grandPrix.endDate,
              now: now,
            ),
          ).called(1);
          verify(
            () => dateService.getDurationToDateFromNow(
              grandPrixesWithPoints[2].grandPrix.startDate,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should define status for each grand prix and should set '
        'GrandPrixStatusNext for gp with roundNumber equal to 1 if there is no '
        'gp with ongoing status',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          getPlayerPointsUseCase.mock(points: 30);
          getGrandPrixesWithPointsUseCase.mock(
            grandPrixesWithPoints: grandPrixesWithPoints,
          );
          dateService.mockGetNowStream(expectedNow: now);
          betsGpStatusService.mockDefineStatusForGp(
            expectedGpStatus: const GrandPrixStatusUpcoming(),
          );
          dateService.mockGetDurationToDateFromNow(
            duration: const Duration(hours: 2, minutes: 34),
          );
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          BetsState(
            status: BetsStateStatus.completed,
            loggedUserId: loggedUserId,
            totalPoints: 30,
            grandPrixItems: [
              GrandPrixItemParams(
                status: const GrandPrixStatusUpcoming(),
                grandPrix: grandPrixesWithPoints[0].grandPrix,
                betPoints: grandPrixesWithPoints[0].points,
              ),
              GrandPrixItemParams(
                status: const GrandPrixStatusNext(
                  durationToStart: Duration(hours: 2, minutes: 34),
                ),
                grandPrix: grandPrixesWithPoints[1].grandPrix,
                betPoints: grandPrixesWithPoints[1].points,
              ),
              GrandPrixItemParams(
                status: const GrandPrixStatusUpcoming(),
                grandPrix: grandPrixesWithPoints[2].grandPrix,
                betPoints: grandPrixesWithPoints[2].points,
              ),
              GrandPrixItemParams(
                status: const GrandPrixStatusUpcoming(),
                grandPrix: grandPrixesWithPoints.last.grandPrix,
                betPoints: grandPrixesWithPoints.last.points,
              ),
            ],
          )
        ],
        verify: (_) {
          verify(
            () => getPlayerPointsUseCase.call(
              playerId: loggedUserId,
              season: 2025,
            ),
          ).called(1);
          verify(
            () => getGrandPrixesWithPointsUseCase.call(
              playerId: loggedUserId,
              season: 2025,
            ),
          ).called(1);
          verify(dateService.getNowStream).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[0].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[0].grandPrix.endDate,
              now: now,
            ),
          ).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[1].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[1].grandPrix.endDate,
              now: now,
            ),
          ).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[2].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[2].grandPrix.endDate,
              now: now,
            ),
          ).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints.last.grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints.last.grandPrix.endDate,
              now: now,
            ),
          ).called(1);
          verify(
            () => dateService.getDurationToDateFromNow(
              grandPrixesWithPoints[1].grandPrix.startDate,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should define status for each grand prix and should do nothing more '
        'if there is no gp after ongoing gp',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          getPlayerPointsUseCase.mock(points: 30);
          getGrandPrixesWithPointsUseCase.mock(
            grandPrixesWithPoints: grandPrixesWithPoints,
          );
          dateService.mockGetNowStream(expectedNow: now);
          when(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[0].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[0].grandPrix.endDate,
              now: now,
            ),
          ).thenReturn(const GrandPrixStatusOngoing());
          when(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[1].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[1].grandPrix.endDate,
              now: now,
            ),
          ).thenReturn(const GrandPrixStatusFinished());
          when(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[2].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[2].grandPrix.endDate,
              now: now,
            ),
          ).thenReturn(const GrandPrixStatusFinished());
          when(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints.last.grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints.last.grandPrix.endDate,
              now: now,
            ),
          ).thenReturn(const GrandPrixStatusFinished());
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          BetsState(
            status: BetsStateStatus.completed,
            loggedUserId: loggedUserId,
            totalPoints: 30,
            grandPrixItems: [
              GrandPrixItemParams(
                status: const GrandPrixStatusOngoing(),
                grandPrix: grandPrixesWithPoints[0].grandPrix,
                betPoints: grandPrixesWithPoints[0].points,
              ),
              GrandPrixItemParams(
                status: const GrandPrixStatusFinished(),
                grandPrix: grandPrixesWithPoints[1].grandPrix,
                betPoints: grandPrixesWithPoints[1].points,
              ),
              GrandPrixItemParams(
                status: const GrandPrixStatusFinished(),
                grandPrix: grandPrixesWithPoints[2].grandPrix,
                betPoints: grandPrixesWithPoints[2].points,
              ),
              GrandPrixItemParams(
                status: const GrandPrixStatusFinished(),
                grandPrix: grandPrixesWithPoints.last.grandPrix,
                betPoints: grandPrixesWithPoints.last.points,
              ),
            ],
          )
        ],
        verify: (_) {
          verify(
            () => getPlayerPointsUseCase.call(
              playerId: loggedUserId,
              season: 2025,
            ),
          ).called(1);
          verify(
            () => getGrandPrixesWithPointsUseCase.call(
              playerId: loggedUserId,
              season: 2025,
            ),
          ).called(1);
          verify(dateService.getNowStream).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[0].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[0].grandPrix.endDate,
              now: now,
            ),
          ).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[1].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[1].grandPrix.endDate,
              now: now,
            ),
          ).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints[2].grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints[2].grandPrix.endDate,
              now: now,
            ),
          ).called(1);
          verify(
            () => betsGpStatusService.defineStatusForGp(
              gpStartDateTime: grandPrixesWithPoints.last.grandPrix.startDate,
              gpEndDateTime: grandPrixesWithPoints.last.grandPrix.endDate,
              now: now,
            ),
          ).called(1);
        },
      );
    },
  );
}
