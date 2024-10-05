import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/screen/home/cubit/home_cubit.dart';
import 'package:betgrid/ui/screen/home/cubit/home_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../creator/user_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../../mock/data/repository/mock_user_repository.dart';
import '../../../mock/ui/mock_date_service.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  final grandPrixRepository = MockGrandPrixRepository();
  final dateService = MockDateService();

  HomeCubit createCubit() => HomeCubit(
        authRepository,
        userRepository,
        grandPrixBetRepository,
        grandPrixRepository,
        dateService,
      );

  tearDown(() {
    reset(authRepository);
    reset(userRepository);
    reset(grandPrixBetRepository);
    reset(grandPrixRepository);
    reset(dateService);
  });

  group(
    'initialize, ',
    () {
      const String loggedUserId = 'u1';
      final DateTime now = DateTime(2024);
      final User loggedUser = UserCreator(
        id: loggedUserId,
        username: 'username',
        avatarUrl: 'avatar/url',
      ).createEntity();
      final HomeState expectedState = HomeState(
        status: HomeStateStatus.completed,
        username: loggedUser.username,
        avatarUrl: loggedUser.avatarUrl,
      );

      setUp(() {
        authRepository.mockGetLoggedUserId(loggedUserId);
        userRepository.mockGetUserById(user: loggedUser);
      });

      tearDown(() {
        verify(() => authRepository.loggedUserId$).called(1);
      });

      blocTest(
        'should emit state with loggedUserDoesNotExist status if logged user '
        'id is null',
        setUp: () => authRepository.mockGetLoggedUserId(null),
        build: () => createCubit(),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          const HomeState(
            status: HomeStateStatus.loggedUserDoesNotExist,
          )
        ],
      );

      blocTest(
        'should emit state with loggedUserDataNotCompleted status if logged '
        'user data does not exist',
        setUp: () => userRepository.mockGetUserById(user: null),
        build: () => createCubit(),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          const HomeState(
            status: HomeStateStatus.loggedUserDataNotCompleted,
          )
        ],
        verify: (_) => verify(
          () => userRepository.getUserById(userId: loggedUserId),
        ).called(1),
      );

      blocTest(
        'should emit state with username, avatarUrl and status set as '
        'completed if logged user already has bets',
        setUp: () => grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
          grandPrixBets: [
            GrandPrixBetCreator(id: 'gpb1').createEntity(),
            GrandPrixBetCreator(id: 'gpb2').createEntity(),
          ],
        ),
        build: () => createCubit(),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          expectedState,
        ],
        verify: (_) {
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
              playerId: loggedUserId,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should emit state with username, avatarUrl and status set as '
        "completed if list of logged user's bets is null and list of all "
        'grand prixes is null',
        setUp: () {
          grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
            grandPrixBets: null,
          );
          dateService.mockGetNow(now: now);
          grandPrixRepository.mockGetAllGrandPrixesFromSeason();
        },
        build: () => createCubit(),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          expectedState,
        ],
        verify: (_) {
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
              playerId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => grandPrixRepository.getAllGrandPrixesFromSeason(now.year),
          ).called(1);
        },
      );

      blocTest(
        'should emit state with username, avatarUrl and status set as '
        "completed if list of logged user's bets is null and list of all "
        'grand prixes is empty',
        setUp: () {
          grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
            grandPrixBets: null,
          );
          dateService.mockGetNow(now: now);
          grandPrixRepository.mockGetAllGrandPrixesFromSeason(
            expectedGrandPrixes: [],
          );
        },
        build: () => createCubit(),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          expectedState,
        ],
        verify: (_) {
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
              playerId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => grandPrixRepository.getAllGrandPrixesFromSeason(now.year),
          ).called(1);
        },
      );

      blocTest(
        'should emit state with username, avatarUrl and status set as '
        "completed if list of logged user's bets is empty and list of all "
        'grand prixes is null',
        setUp: () {
          grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
            grandPrixBets: [],
          );
          dateService.mockGetNow(now: now);
          grandPrixRepository.mockGetAllGrandPrixesFromSeason();
        },
        build: () => createCubit(),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          expectedState,
        ],
        verify: (_) {
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
              playerId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => grandPrixRepository.getAllGrandPrixesFromSeason(now.year),
          ).called(1);
        },
      );

      blocTest(
        'should emit state with username, avatarUrl and status set as '
        "completed if list of logged user's bets is empty and list of all "
        'grand prixes is empty',
        setUp: () {
          grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
            grandPrixBets: [],
          );
          dateService.mockGetNow(now: now);
          grandPrixRepository.mockGetAllGrandPrixesFromSeason(
            expectedGrandPrixes: [],
          );
        },
        build: () => createCubit(),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          expectedState,
        ],
        verify: (_) {
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
              playerId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => grandPrixRepository.getAllGrandPrixesFromSeason(now.year),
          ).called(1);
        },
      );

      blocTest(
        'should create default bets for each grand prix and should emit state '
        'with username, avatarUrl and status set as completed',
        setUp: () {
          grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
            grandPrixBets: null,
          );
          dateService.mockGetNow(now: now);
          grandPrixRepository.mockGetAllGrandPrixesFromSeason(
            expectedGrandPrixes: [
              GrandPrixCreator(id: 'gp1').createEntity(),
              GrandPrixCreator(id: 'gp2').createEntity(),
              GrandPrixCreator(id: 'gp3').createEntity(),
            ],
          );
          grandPrixBetRepository.mockAddGrandPrixBetsForPlayer();
        },
        build: () => createCubit(),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          expectedState,
        ],
        verify: (_) {
          verify(() => userRepository.getUserById(userId: loggedUserId))
              .called(1);
          verify(
            () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
              playerId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => grandPrixRepository.getAllGrandPrixesFromSeason(now.year),
          ).called(1);
          verify(
            () => grandPrixBetRepository.addGrandPrixBetsForPlayer(
              playerId: loggedUserId,
              grandPrixBets: [
                GrandPrixBetCreator(
                  playerId: loggedUserId,
                  grandPrixId: 'gp1',
                ).createEntity(),
                GrandPrixBetCreator(
                  playerId: loggedUserId,
                  grandPrixId: 'gp2',
                ).createEntity(),
                GrandPrixBetCreator(
                  playerId: loggedUserId,
                  grandPrixId: 'gp3',
                ).createEntity(),
              ],
            ),
          ).called(1);
        },
      );
    },
  );
}
