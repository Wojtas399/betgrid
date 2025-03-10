import 'package:betgrid/ui/screen/season_grand_prix_bets/cubit/season_grand_prix_bets_cubit.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bets/cubit/season_grand_prix_bets_state.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/repository/mock_auth_repository.dart';
import '../../../mock/ui/mock_date_service.dart';
import '../../../mock/ui/mock_season_cubit.dart';
import '../../../mock/ui/screen/mock_bets_gp_status_service.dart';
import '../../../mock/use_case/mock_get_grand_prixes_with_points_use_case.dart';
import '../../../mock/use_case/mock_get_player_points_use_case.dart';

void main() {
  final authRepository = MockAuthRepository();
  final getGrandPrixesWithPointsUseCase = MockGetGrandPrixesWithPointsUseCase();
  final getPlayerPointsUseCase = MockGetPlayerPointsUseCase();
  final betsGpStatusService = MockSeasonGrandPrixBetsGpStatusService();
  final dateService = MockDateService();
  final seasonCubit = MockSeasonCubit();

  SeasonGrandPrixBetsCubit createCubit() => SeasonGrandPrixBetsCubit(
    authRepository,
    getPlayerPointsUseCase,
    getGrandPrixesWithPointsUseCase,
    betsGpStatusService,
    dateService,
    seasonCubit,
  );

  tearDown(() {
    reset(authRepository);
    reset(getGrandPrixesWithPointsUseCase);
    reset(getPlayerPointsUseCase);
    reset(betsGpStatusService);
    reset(dateService);
    reset(seasonCubit);
  });

  group('initialize, ', () {
    const String loggedUserId = 'u1';
    final DateTime now = DateTime(2025, 1, 1);
    final List<GrandPrixWithPoints> grandPrixesWithPoints = [
      GrandPrixWithPoints(
        seasonGrandPrixId: 'gp4',
        name: 'gp4',
        countryAlpha2Code: 'FR',
        roundNumber: 4,
        startDate: DateTime(2025, 4, 1),
        endDate: DateTime(2025, 4, 2),
        points: 10.0,
      ),
      GrandPrixWithPoints(
        seasonGrandPrixId: 'gp1',
        name: 'gp1',
        countryAlpha2Code: 'FR',
        roundNumber: 1,
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 2),
        points: 20.0,
      ),
      GrandPrixWithPoints(
        seasonGrandPrixId: 'gp3',
        name: 'gp3',
        countryAlpha2Code: 'FR',
        roundNumber: 3,
        startDate: DateTime(2025, 3, 1),
        endDate: DateTime(2025, 3, 2),
        points: 30.0,
      ),
      GrandPrixWithPoints(
        seasonGrandPrixId: 'gp2',
        name: 'gp2',
        countryAlpha2Code: 'FR',
        roundNumber: 2,
        startDate: DateTime(2025, 2, 1),
        endDate: DateTime(2025, 2, 2),
        points: 10.0,
      ),
    ];
    SeasonGrandPrixBetsState? state;

    setUp(() {
      dateService.mockGetNow(now: now);
      seasonCubit.mockState(expectedState: now.year);
    });

    tearDown(() {
      verify(() => authRepository.loggedUserId$).called(1);
    });

    blocTest(
      'should emit state with loggedUserDoesNotExist status if logged user '
      'does not exist',
      build: () => createCubit(),
      setUp: () => authRepository.mockGetLoggedUserId(null),
      act: (cubit) => cubit.initialize(),
      expect:
          () => [
            const SeasonGrandPrixBetsState(
              status: SeasonGrandPrixBetsStateStatus.loggedUserDoesNotExist,
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
      },
      act: (cubit) => cubit.initialize(),
      expect:
          () => [
            SeasonGrandPrixBetsState(
              status: SeasonGrandPrixBetsStateStatus.noBets,
              loggedUserId: loggedUserId,
              season: now.year,
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
      'should define status for each grand prix and should find first gp '
      'after ongoing gp and should set GrandPrixStatusNext for it with '
      'calculated duration to start (grand prixes should be sorted by round '
      'number)',
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
            gpStartDateTime: grandPrixesWithPoints[0].startDate,
            gpEndDateTime: grandPrixesWithPoints[0].endDate,
            now: now,
          ),
        ).thenReturn(const SeasonGrandPrixStatusUpcoming());
        when(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[1].startDate,
            gpEndDateTime: grandPrixesWithPoints[1].endDate,
            now: now,
          ),
        ).thenReturn(const SeasonGrandPrixStatusFinished());
        when(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[2].startDate,
            gpEndDateTime: grandPrixesWithPoints[2].endDate,
            now: now,
          ),
        ).thenReturn(const SeasonGrandPrixStatusUpcoming());
        when(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints.last.startDate,
            gpEndDateTime: grandPrixesWithPoints.last.endDate,
            now: now,
          ),
        ).thenReturn(const SeasonGrandPrixStatusOngoing());
        dateService.mockGetDurationToDateFromNow(
          duration: const Duration(days: 1, minutes: 34),
        );
      },
      act: (cubit) => cubit.initialize(),
      expect:
          () => [
            state = SeasonGrandPrixBetsState(
              status: SeasonGrandPrixBetsStateStatus.completed,
              loggedUserId: loggedUserId,
              season: now.year,
              totalPoints: 30,
              grandPrixItems: [
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusFinished(),
                  seasonGrandPrixId: grandPrixesWithPoints[1].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[1].name,
                  countryAlpha2Code: grandPrixesWithPoints[1].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[1].roundNumber,
                  startDate: grandPrixesWithPoints[1].startDate,
                  endDate: grandPrixesWithPoints[1].endDate,
                  betPoints: grandPrixesWithPoints[1].points,
                ),
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusOngoing(),
                  seasonGrandPrixId: grandPrixesWithPoints[3].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[3].name,
                  countryAlpha2Code: grandPrixesWithPoints[3].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[3].roundNumber,
                  startDate: grandPrixesWithPoints[3].startDate,
                  endDate: grandPrixesWithPoints[3].endDate,
                  betPoints: grandPrixesWithPoints[3].points,
                ),
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusNext(),
                  seasonGrandPrixId: grandPrixesWithPoints[2].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[2].name,
                  countryAlpha2Code: grandPrixesWithPoints[2].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[2].roundNumber,
                  startDate: grandPrixesWithPoints[2].startDate,
                  endDate: grandPrixesWithPoints[2].endDate,
                  betPoints: grandPrixesWithPoints[2].points,
                ),
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusUpcoming(),
                  seasonGrandPrixId: grandPrixesWithPoints[0].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[0].name,
                  countryAlpha2Code: grandPrixesWithPoints[0].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[0].roundNumber,
                  startDate: grandPrixesWithPoints[0].startDate,
                  endDate: grandPrixesWithPoints[0].endDate,
                  betPoints: grandPrixesWithPoints[0].points,
                ),
              ],
            ),
            state = state!.copyWith(
              durationToStartNextGp: const Duration(days: 1, minutes: 34),
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
        verify(dateService.getNowStream).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[0].startDate,
            gpEndDateTime: grandPrixesWithPoints[0].endDate,
            now: now,
          ),
        ).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[1].startDate,
            gpEndDateTime: grandPrixesWithPoints[1].endDate,
            now: now,
          ),
        ).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[2].startDate,
            gpEndDateTime: grandPrixesWithPoints[2].endDate,
            now: now,
          ),
        ).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints.last.startDate,
            gpEndDateTime: grandPrixesWithPoints.last.endDate,
            now: now,
          ),
        ).called(1);
        verify(
          () => dateService.getDurationToDateFromNow(
            grandPrixesWithPoints[2].startDate,
          ),
        ).called(1);
      },
    );

    blocTest(
      'should define status for each grand prix and should set '
      'GrandPrixStatusNext for gp with roundNumber equal to 1 if there is no '
      'gp with ongoing status (grand prixes should be sorted by round '
      'number)',
      build: () => createCubit(),
      setUp: () {
        authRepository.mockGetLoggedUserId(loggedUserId);
        getPlayerPointsUseCase.mock(points: 30);
        getGrandPrixesWithPointsUseCase.mock(
          grandPrixesWithPoints: grandPrixesWithPoints,
        );
        dateService.mockGetNowStream(expectedNow: now);
        betsGpStatusService.mockDefineStatusForGp(
          expectedGpStatus: const SeasonGrandPrixStatusUpcoming(),
        );
        dateService.mockGetDurationToDateFromNow(
          duration: const Duration(hours: 2, minutes: 34),
        );
      },
      act: (cubit) => cubit.initialize(),
      expect:
          () => [
            state = SeasonGrandPrixBetsState(
              status: SeasonGrandPrixBetsStateStatus.completed,
              loggedUserId: loggedUserId,
              season: now.year,
              totalPoints: 30,
              grandPrixItems: [
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusNext(),
                  seasonGrandPrixId: grandPrixesWithPoints[1].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[1].name,
                  countryAlpha2Code: grandPrixesWithPoints[1].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[1].roundNumber,
                  startDate: grandPrixesWithPoints[1].startDate,
                  endDate: grandPrixesWithPoints[1].endDate,
                  betPoints: grandPrixesWithPoints[1].points,
                ),
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusUpcoming(),
                  seasonGrandPrixId: grandPrixesWithPoints[3].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[3].name,
                  countryAlpha2Code: grandPrixesWithPoints[3].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[3].roundNumber,
                  startDate: grandPrixesWithPoints[3].startDate,
                  endDate: grandPrixesWithPoints[3].endDate,
                  betPoints: grandPrixesWithPoints[3].points,
                ),
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusUpcoming(),
                  seasonGrandPrixId: grandPrixesWithPoints[2].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[2].name,
                  countryAlpha2Code: grandPrixesWithPoints[2].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[2].roundNumber,
                  startDate: grandPrixesWithPoints[2].startDate,
                  endDate: grandPrixesWithPoints[2].endDate,
                  betPoints: grandPrixesWithPoints[2].points,
                ),
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusUpcoming(),
                  seasonGrandPrixId: grandPrixesWithPoints[0].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[0].name,
                  countryAlpha2Code: grandPrixesWithPoints[0].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[0].roundNumber,
                  startDate: grandPrixesWithPoints[0].startDate,
                  endDate: grandPrixesWithPoints[0].endDate,
                  betPoints: grandPrixesWithPoints[0].points,
                ),
              ],
            ),
            state = state!.copyWith(
              durationToStartNextGp: const Duration(hours: 2, minutes: 34),
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
        verify(dateService.getNowStream).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[0].startDate,
            gpEndDateTime: grandPrixesWithPoints[0].endDate,
            now: now,
          ),
        ).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[1].startDate,
            gpEndDateTime: grandPrixesWithPoints[1].endDate,
            now: now,
          ),
        ).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[2].startDate,
            gpEndDateTime: grandPrixesWithPoints[2].endDate,
            now: now,
          ),
        ).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints.last.startDate,
            gpEndDateTime: grandPrixesWithPoints.last.endDate,
            now: now,
          ),
        ).called(1);
        verify(
          () => dateService.getDurationToDateFromNow(
            grandPrixesWithPoints[1].startDate,
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
            gpStartDateTime: grandPrixesWithPoints[0].startDate,
            gpEndDateTime: grandPrixesWithPoints[0].endDate,
            now: now,
          ),
        ).thenReturn(const SeasonGrandPrixStatusOngoing());
        when(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[1].startDate,
            gpEndDateTime: grandPrixesWithPoints[1].endDate,
            now: now,
          ),
        ).thenReturn(const SeasonGrandPrixStatusFinished());
        when(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[2].startDate,
            gpEndDateTime: grandPrixesWithPoints[2].endDate,
            now: now,
          ),
        ).thenReturn(const SeasonGrandPrixStatusFinished());
        when(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints.last.startDate,
            gpEndDateTime: grandPrixesWithPoints.last.endDate,
            now: now,
          ),
        ).thenReturn(const SeasonGrandPrixStatusFinished());
      },
      act: (cubit) => cubit.initialize(),
      expect:
          () => [
            SeasonGrandPrixBetsState(
              status: SeasonGrandPrixBetsStateStatus.completed,
              loggedUserId: loggedUserId,
              season: now.year,
              totalPoints: 30,
              grandPrixItems: [
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusFinished(),
                  seasonGrandPrixId: grandPrixesWithPoints[1].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[1].name,
                  countryAlpha2Code: grandPrixesWithPoints[1].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[1].roundNumber,
                  startDate: grandPrixesWithPoints[1].startDate,
                  endDate: grandPrixesWithPoints[1].endDate,
                  betPoints: grandPrixesWithPoints[1].points,
                ),
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusFinished(),
                  seasonGrandPrixId: grandPrixesWithPoints[3].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[3].name,
                  countryAlpha2Code: grandPrixesWithPoints[3].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[3].roundNumber,
                  startDate: grandPrixesWithPoints[3].startDate,
                  endDate: grandPrixesWithPoints[3].endDate,
                  betPoints: grandPrixesWithPoints[3].points,
                ),
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusFinished(),
                  seasonGrandPrixId: grandPrixesWithPoints[2].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[2].name,
                  countryAlpha2Code: grandPrixesWithPoints[2].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[2].roundNumber,
                  startDate: grandPrixesWithPoints[2].startDate,
                  endDate: grandPrixesWithPoints[2].endDate,
                  betPoints: grandPrixesWithPoints[2].points,
                ),
                SeasonGrandPrixItemParams(
                  status: const SeasonGrandPrixStatusOngoing(),
                  seasonGrandPrixId: grandPrixesWithPoints[0].seasonGrandPrixId,
                  grandPrixName: grandPrixesWithPoints[0].name,
                  countryAlpha2Code: grandPrixesWithPoints[0].countryAlpha2Code,
                  roundNumber: grandPrixesWithPoints[0].roundNumber,
                  startDate: grandPrixesWithPoints[0].startDate,
                  endDate: grandPrixesWithPoints[0].endDate,
                  betPoints: grandPrixesWithPoints[0].points,
                ),
              ],
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
        verify(dateService.getNowStream).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[0].startDate,
            gpEndDateTime: grandPrixesWithPoints[0].endDate,
            now: now,
          ),
        ).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[1].startDate,
            gpEndDateTime: grandPrixesWithPoints[1].endDate,
            now: now,
          ),
        ).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints[2].startDate,
            gpEndDateTime: grandPrixesWithPoints[2].endDate,
            now: now,
          ),
        ).called(1);
        verify(
          () => betsGpStatusService.defineStatusForGp(
            gpStartDateTime: grandPrixesWithPoints.last.startDate,
            gpEndDateTime: grandPrixesWithPoints.last.endDate,
            now: now,
          ),
        ).called(1);
      },
    );
  });
}
