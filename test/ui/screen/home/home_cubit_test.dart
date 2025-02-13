import 'package:betgrid/model/player_stats.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/screen/home/cubit/home_cubit.dart';
import 'package:betgrid/ui/screen/home/cubit/home_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/player_stats_creator.dart';
import '../../../creator/user_creator.dart';
import '../../../mock/repository/mock_auth_repository.dart';
import '../../../mock/repository/mock_player_stats_repository.dart';
import '../../../mock/repository/mock_user_repository.dart';
import '../../../mock/ui/mock_date_service.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();
  final playerStatsRepository = MockPlayerStatsRepository();
  final dateService = MockDateService();

  HomeCubit createCubit() => HomeCubit(
        authRepository,
        userRepository,
        playerStatsRepository,
        dateService,
      );

  tearDown(() {
    reset(authRepository);
    reset(userRepository);
    reset(playerStatsRepository);
    reset(dateService);
  });

  group(
    'initialize, ',
    () {
      const String loggedUserId = 'u1';
      const int season = 2024;
      final User loggedUser = const UserCreator(
        id: loggedUserId,
        username: 'username',
        avatarUrl: 'avatar/url',
      ).create();
      final PlayerStats stats = PlayerStatsCreator(
        totalPoints: 100,
      ).create();

      tearDown(() {
        verify(() => authRepository.loggedUserId$).called(1);
      });

      blocTest(
        'should emit state with loggedUserDoesNotExist status if logged user '
        'id is null',
        setUp: () => authRepository.mockGetLoggedUserId(null),
        build: () => createCubit(),
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const HomeState(
            status: HomeStateStatus.loggedUserDoesNotExist,
          )
        ],
      );

      blocTest(
        'should emit state with loggedUserDataNotCompleted status if logged '
        'user does not have personal data',
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockGetById(user: null);
          dateService.mockGetNow(now: DateTime(season));
          playerStatsRepository.mockGetByPlayerIdAndSeason(
            expectedPlayerStats: stats,
          );
        },
        build: () => createCubit(),
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const HomeState(
            status: HomeStateStatus.loggedUserDataNotCompleted,
          )
        ],
      );

      blocTest(
        'should emit state with loggedUserDataNotCompleted status if logged '
        'user does not have stats',
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockGetById(user: loggedUser);
          dateService.mockGetNow(now: DateTime(season));
          playerStatsRepository.mockGetByPlayerIdAndSeason(
            expectedPlayerStats: null,
          );
        },
        build: () => createCubit(),
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const HomeState(
            status: HomeStateStatus.loggedUserDataNotCompleted,
          )
        ],
      );

      blocTest(
        'should emit state with username, avatarUrl, totalPoints and status '
        'set as completed if logged user has personal data',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockGetById(user: loggedUser);
          dateService.mockGetNow(now: DateTime(season));
          playerStatsRepository.mockGetByPlayerIdAndSeason(
            expectedPlayerStats: stats,
          );
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          HomeState(
            status: HomeStateStatus.completed,
            username: loggedUser.username,
            avatarUrl: loggedUser.avatarUrl,
            totalPoints: stats.totalPoints,
          ),
        ],
      );
    },
  );
}
