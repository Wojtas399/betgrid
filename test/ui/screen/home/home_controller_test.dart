import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/screen/home/controller/home_controller.dart';
import 'package:betgrid/ui/screen/home/state/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../mock/auth/mock_auth_service.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final grandPrixRepository = MockGrandPrixRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();

  ProviderContainer makeProviderContainer(
    MockAuthService authService,
    MockGrandPrixRepository grandPrixRepository,
    MockGrandPrixBetRepository grandPrixBetRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(authService),
        grandPrixRepositoryProvider.overrideWithValue(grandPrixRepository),
        grandPrixBetRepositoryProvider.overrideWithValue(
          grandPrixBetRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(authService);
    reset(grandPrixRepository);
    reset(grandPrixBetRepository);
  });

  const String loggedUserId = 'u1';
  final GrandPrix gp1 = GrandPrix(
    id: 'gp1',
    name: 'Grand Prix 1',
    startDate: DateTime(2023, 1, 1),
    endDate: DateTime(2023, 1, 3),
  );
  final GrandPrix gp2 = GrandPrix(
    id: 'gp2',
    name: 'Grand Prix 2',
    startDate: DateTime(2023, 1, 5),
    endDate: DateTime(2023, 1, 7),
  );
  final GrandPrix gp3 = GrandPrix(
    id: 'gp3',
    name: 'Grand Prix 3',
    startDate: DateTime(2023, 1, 9),
    endDate: DateTime(2023, 1, 11),
  );

  test(
    'build, '
    'should return HomeStateLoggedUserNotFound state if logged user does not exist',
    () async {
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      final listener = Listener<AsyncValue<HomeState>>();
      container.listen(
        homeControllerProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(homeControllerProvider.notifier);

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<HomeState>(),
            ),
        () => listener(
              const AsyncLoading<HomeState>(),
              const AsyncData<HomeState>(HomeStateLoggedUserNotFound()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
    },
  );

  test(
    'build, '
    'should load all grand prixes from GrandPrixRepository, '
    'should return loaded grand prixes in HomeStateDataLoaded state sorted by date, '
    'if grand prix bets are not initialized should initialize them',
    () async {
      authService.mockGetLoggedUserId(loggedUserId);
      grandPrixRepository.mockLoadAllGrandPrixes([gp3, gp1, gp2]);
      grandPrixBetRepository.mockGetAllGrandPrixBets(null);
      grandPrixBetRepository.mockAddGrandPrixBets();
      final container = makeProviderContainer(
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      final listener = Listener<AsyncValue<HomeState>>();
      container.listen(
        homeControllerProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(homeControllerProvider.notifier);

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<HomeState>(),
            ),
        () => listener(
              const AsyncLoading<HomeState>(),
              AsyncData<HomeState>(
                HomeStateDataLoaded(grandPrixes: [gp1, gp2, gp3]),
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(grandPrixRepository.loadAllGrandPrixes).called(1);
      verify(
        () => grandPrixBetRepository.addGrandPrixBets(
          userId: loggedUserId,
          grandPrixBets: [
            createGrandPrixBet(grandPrixId: gp1.id),
            createGrandPrixBet(grandPrixId: gp2.id),
            createGrandPrixBet(grandPrixId: gp3.id),
          ],
        ),
      ).called(1);
    },
  );

  test(
    'build, '
    'should load all grand prixes from GrandPrixRepository, '
    'should return loaded grand prixes in HomeStateDataLoaded state sorted by date, '
    'if list of grand prix bets is empty should initialize them',
    () async {
      authService.mockGetLoggedUserId(loggedUserId);
      grandPrixRepository.mockLoadAllGrandPrixes([gp3, gp1, gp2]);
      grandPrixBetRepository.mockGetAllGrandPrixBets([]);
      grandPrixBetRepository.mockAddGrandPrixBets();
      final container = makeProviderContainer(
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      final listener = Listener<AsyncValue<HomeState>>();
      container.listen(
        homeControllerProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(homeControllerProvider.notifier);

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<HomeState>(),
            ),
        () => listener(
              const AsyncLoading<HomeState>(),
              AsyncData<HomeState>(
                HomeStateDataLoaded(grandPrixes: [gp1, gp2, gp3]),
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(grandPrixRepository.loadAllGrandPrixes).called(1);
      verify(
        () => grandPrixBetRepository.addGrandPrixBets(
          userId: loggedUserId,
          grandPrixBets: [
            createGrandPrixBet(grandPrixId: gp1.id),
            createGrandPrixBet(grandPrixId: gp2.id),
            createGrandPrixBet(grandPrixId: gp3.id),
          ],
        ),
      ).called(1);
    },
  );

  test(
    'build, '
    'should load all grand prixes from GrandPrixRepository, '
    'should return loaded grand prixes in HomeStateDataLoaded state sorted by date, '
    'if grand prix bets exist should not initialize them',
    () async {
      authService.mockGetLoggedUserId(loggedUserId);
      grandPrixRepository.mockLoadAllGrandPrixes([gp3, gp1, gp2]);
      grandPrixBetRepository.mockGetAllGrandPrixBets([
        createGrandPrixBet(id: 'gpb1', grandPrixId: gp1.id),
        createGrandPrixBet(id: 'gpb2', grandPrixId: gp2.id),
        createGrandPrixBet(id: 'gpb3', grandPrixId: gp3.id),
      ]);
      grandPrixBetRepository.mockAddGrandPrixBets();
      final container = makeProviderContainer(
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      final listener = Listener<AsyncValue<HomeState>>();
      container.listen(
        homeControllerProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(homeControllerProvider.notifier);

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<HomeState>(),
            ),
        () => listener(
              const AsyncLoading<HomeState>(),
              AsyncData<HomeState>(
                HomeStateDataLoaded(grandPrixes: [gp1, gp2, gp3]),
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(grandPrixRepository.loadAllGrandPrixes).called(1);
      verifyNever(
        () => grandPrixBetRepository.addGrandPrixBets(
          userId: loggedUserId,
          grandPrixBets: [
            createGrandPrixBet(grandPrixId: gp1.id),
            createGrandPrixBet(grandPrixId: gp2.id),
            createGrandPrixBet(grandPrixId: gp3.id),
          ],
        ),
      );
    },
  );
}
