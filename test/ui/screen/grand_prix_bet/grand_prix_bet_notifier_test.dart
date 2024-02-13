import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/ui/riverpod_provider/grand_prix_id_provider.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/notifier/grand_prix_bet_notifier.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/notifier/grand_prix_bet_notifier_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../mock/auth/mock_auth_service.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final grandPrixRepository = MockGrandPrixRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  const String loggedUserId = 'u1';
  const String grandPrixId = 'gp1';
  final List<String?> defaultQualificationsStandings =
      List.generate(20, (_) => null);
  final List<String?> defaultDnfDriverIds = List.generate(3, (_) => null);
  late Listener<AsyncValue<GrandPrixBetNotifierState?>> listener;

  ProviderContainer makeProviderContainer(
    String grandPrixId,
    MockAuthService authService,
    MockGrandPrixRepository grandPrixRepository,
    MockGrandPrixBetRepository grandPrixBetRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
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

  setUp(() {
    authService.mockGetLoggedUserId(loggedUserId);
    grandPrixRepository.mockLoadGrandPrixById(null);
    grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
      createGrandPrixBet(grandPrixId: grandPrixId),
    );
    listener = Listener<AsyncValue<GrandPrixBetNotifierState?>>();
  });

  tearDown(() {
    reset(authService);
    reset(grandPrixRepository);
    reset(grandPrixBetRepository);
  });

  test(
    'build, '
    'should load grand prix name and should'
    'should watch to grand prix bet and emit its bet values',
    () async {
      const String grandPrixName = 'Bahrain';
      final GrandPrixBet grandPrixBet = createGrandPrixBet(
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: List.generate(
          20,
          (index) => switch (index) {
            1 => 'd2',
            5 => 'd10',
            11 => 'd15',
            _ => null,
          },
        ),
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd3',
        p10DriverId: 'd4',
        fastestLapDriverId: 'd1',
        dnfDriverIds: ['d17', 'd18', 'd19'],
        willBeSafetyCar: true,
        willBeRedFlag: false,
      );
      final GrandPrixBetNotifierState expectedState = GrandPrixBetNotifierState(
        grandPrixName: grandPrixName,
        qualiStandingsByDriverIds: grandPrixBet.qualiStandingsByDriverIds,
        p1DriverId: grandPrixBet.p1DriverId,
        p2DriverId: grandPrixBet.p2DriverId,
        p3DriverId: grandPrixBet.p3DriverId,
        p10DriverId: grandPrixBet.p10DriverId,
        fastestLapDriverId: grandPrixBet.fastestLapDriverId,
        dnfDriverIds: grandPrixBet.dnfDriverIds,
        willBeSafetyCar: grandPrixBet.willBeSafetyCar,
        willBeRedFlag: grandPrixBet.willBeRedFlag,
      );
      grandPrixRepository.mockLoadGrandPrixById(
        createGrandPrix(name: grandPrixName),
      );
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(grandPrixBet);
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      container.listen(
        grandPrixBetNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetNotifierProvider.future),
        completion(expectedState),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<GrandPrixBetNotifierState?>(),
            ),
        () => listener(
              const AsyncLoading<GrandPrixBetNotifierState?>(),
              AsyncData(expectedState),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: loggedUserId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'onQualificationDriverChanged, '
    'should update driver id on given index in qualification standings',
    () async {
      const int index = 5;
      const String driverId = 'd2';
      final List<String?> expectedList = List.generate(
        20,
        (i) => index == i ? driverId : null,
      );
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(
          qualiStandingsByDriverIds: defaultQualificationsStandings,
        ),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      container.listen(
        grandPrixBetNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        grandPrixBetNotifierProvider.notifier,
      );

      await notifier.future;
      notifier.onQualificationDriverChanged(index, driverId);

      await expectLater(
        container.read(grandPrixBetNotifierProvider.future),
        completion(GrandPrixBetNotifierState(
          qualiStandingsByDriverIds: expectedList,
          dnfDriverIds: defaultDnfDriverIds,
        )),
      );
    },
  );

  test(
    'onP1DriverChanged, '
    'should update p1DriverId param in state',
    () async {
      const String p1DriverId = 'd1';
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      container.listen(
        grandPrixBetNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        grandPrixBetNotifierProvider.notifier,
      );

      await notifier.future;
      notifier.onP1DriverChanged(p1DriverId);

      await expectLater(
        container.read(grandPrixBetNotifierProvider.future),
        completion(GrandPrixBetNotifierState(
          qualiStandingsByDriverIds: defaultQualificationsStandings,
          p1DriverId: p1DriverId,
          dnfDriverIds: defaultDnfDriverIds,
        )),
      );
    },
  );

  test(
    'onP2DriverChanged, '
    'should update p2DriverId param in state',
    () async {
      const String p2DriverId = 'd1';
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      container.listen(
        grandPrixBetNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        grandPrixBetNotifierProvider.notifier,
      );

      await notifier.future;
      notifier.onP2DriverChanged(p2DriverId);

      await expectLater(
        container.read(grandPrixBetNotifierProvider.future),
        completion(GrandPrixBetNotifierState(
          qualiStandingsByDriverIds: defaultQualificationsStandings,
          p2DriverId: p2DriverId,
          dnfDriverIds: defaultDnfDriverIds,
        )),
      );
    },
  );

  test(
    'onP3DriverChanged, '
    'should update p3DriverId param in state',
    () async {
      const String p3DriverId = 'd1';
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      container.listen(
        grandPrixBetNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        grandPrixBetNotifierProvider.notifier,
      );

      await notifier.future;
      notifier.onP3DriverChanged(p3DriverId);

      await expectLater(
        container.read(grandPrixBetNotifierProvider.future),
        completion(GrandPrixBetNotifierState(
          qualiStandingsByDriverIds: defaultQualificationsStandings,
          p3DriverId: p3DriverId,
          dnfDriverIds: defaultDnfDriverIds,
        )),
      );
    },
  );

  test(
    'onP10DriverChanged, '
    'should update p10DriverId param in state',
    () async {
      const String p10DriverId = 'd1';
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      container.listen(
        grandPrixBetNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        grandPrixBetNotifierProvider.notifier,
      );

      await notifier.future;
      notifier.onP10DriverChanged(p10DriverId);

      await expectLater(
        container.read(grandPrixBetNotifierProvider.future),
        completion(GrandPrixBetNotifierState(
          qualiStandingsByDriverIds: defaultQualificationsStandings,
          p10DriverId: p10DriverId,
          dnfDriverIds: defaultDnfDriverIds,
        )),
      );
    },
  );

  test(
    'onFastestLapDriverChanged, '
    'should update fastestLapDriverId param in state',
    () async {
      const String fastestLapDriverId = 'd1';
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      container.listen(
        grandPrixBetNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        grandPrixBetNotifierProvider.notifier,
      );

      await notifier.future;
      notifier.onFastestLapDriverChanged(fastestLapDriverId);

      await expectLater(
        container.read(grandPrixBetNotifierProvider.future),
        completion(GrandPrixBetNotifierState(
          qualiStandingsByDriverIds: defaultQualificationsStandings,
          fastestLapDriverId: fastestLapDriverId,
          dnfDriverIds: defaultDnfDriverIds,
        )),
      );
    },
  );

  test(
    'onDnfDriverChanged, '
    'should update driver id on given index in dnf list',
    () async {
      const int index = 1;
      const String driverId = 'd2';
      final List<String?> expectedList = [null, driverId, null];
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(dnfDriverIds: defaultDnfDriverIds),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      container.listen(
        grandPrixBetNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        grandPrixBetNotifierProvider.notifier,
      );

      await notifier.future;
      notifier.onDnfDriverChanged(index, driverId);

      await expectLater(
        container.read(grandPrixBetNotifierProvider.future),
        completion(GrandPrixBetNotifierState(
          qualiStandingsByDriverIds: defaultQualificationsStandings,
          dnfDriverIds: expectedList,
        )),
      );
    },
  );

  test(
    'onSafetyCarPossibilityChanged, '
    'should update willBeSafetyCar param in state',
    () async {
      const bool willBeSafetyCar = true;
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      container.listen(
        grandPrixBetNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        grandPrixBetNotifierProvider.notifier,
      );

      await notifier.future;
      notifier.onSafetyCarPossibilityChanged(willBeSafetyCar);

      await expectLater(
        container.read(grandPrixBetNotifierProvider.future),
        completion(GrandPrixBetNotifierState(
          qualiStandingsByDriverIds: defaultQualificationsStandings,
          dnfDriverIds: defaultDnfDriverIds,
          willBeSafetyCar: willBeSafetyCar,
        )),
      );
    },
  );

  test(
    'onRedFlagPossibilityChanged, '
    'should update willBeRedFlag param in state',
    () async {
      const bool willBeRedFlag = true;
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      container.listen(
        grandPrixBetNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        grandPrixBetNotifierProvider.notifier,
      );

      await notifier.future;
      notifier.onRedFlagPossibilityChanged(willBeRedFlag);

      await expectLater(
        container.read(grandPrixBetNotifierProvider.future),
        completion(GrandPrixBetNotifierState(
          qualiStandingsByDriverIds: defaultQualificationsStandings,
          dnfDriverIds: defaultDnfDriverIds,
          willBeRedFlag: willBeRedFlag,
        )),
      );
    },
  );

  test(
    'saveStandings, '
    'should should call method from GrandPrixBetRepository to update bet with '
    'qualiStandingsByDriverIds, p1DriverId, p2DriverId, p3DriverId, '
    'p10DriverId, fastestLapDriverId, dnfDriverIds, willBeSafetyCar and '
    'willBeRedFlag params',
    () async {
      const String grandPrixBetId = 'gpb1';
      final List<String?> newStandings = List.generate(
        20,
        (index) => index == 2 ? 'd2' : null,
      );
      const String newP1DriverId = 'd1';
      const String newP2DriverId = 'd2';
      const String newP3DriverId = 'd3';
      const String newP10DriverId = 'd10';
      const String newFastestLapDriverId = 'd11';
      const List<String?> newDnfDriverIds = ['d18', null, null];
      const bool newWillBeSafetyCar = false;
      const bool newWillBeRedFlag = true;
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(id: grandPrixBetId),
      );
      grandPrixBetRepository.mockUpdateGrandPrixBet();
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      container.listen(
        grandPrixBetNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        grandPrixBetNotifierProvider.notifier,
      );

      await notifier.future;
      notifier.onQualificationDriverChanged(2, 'd2');
      notifier.onP1DriverChanged(newP1DriverId);
      notifier.onP2DriverChanged(newP2DriverId);
      notifier.onP3DriverChanged(newP3DriverId);
      notifier.onP10DriverChanged(newP10DriverId);
      notifier.onFastestLapDriverChanged(newFastestLapDriverId);
      notifier.onDnfDriverChanged(0, 'd18');
      notifier.onSafetyCarPossibilityChanged(newWillBeSafetyCar);
      notifier.onRedFlagPossibilityChanged(newWillBeRedFlag);
      await notifier.saveStandings();

      GrandPrixBetNotifierState state = GrandPrixBetNotifierState(
        qualiStandingsByDriverIds: defaultQualificationsStandings,
        dnfDriverIds: defaultDnfDriverIds,
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<GrandPrixBetNotifierState?>(),
            ),
        () => listener(
              const AsyncLoading<GrandPrixBetNotifierState?>(),
              AsyncData<GrandPrixBetNotifierState?>(state),
            ),
        () {
          final previousState = state;
          state = state.copyWith(qualiStandingsByDriverIds: newStandings);
          return listener(
            AsyncData<GrandPrixBetNotifierState?>(previousState),
            AsyncData<GrandPrixBetNotifierState?>(state),
          );
        },
        () {
          final previousState = state;
          state = state.copyWith(p1DriverId: newP1DriverId);
          return listener(
            AsyncData<GrandPrixBetNotifierState?>(previousState),
            AsyncData<GrandPrixBetNotifierState?>(state),
          );
        },
        () {
          final previousState = state;
          state = state.copyWith(p2DriverId: newP2DriverId);
          return listener(
            AsyncData<GrandPrixBetNotifierState?>(previousState),
            AsyncData<GrandPrixBetNotifierState?>(state),
          );
        },
        () {
          final previousState = state;
          state = state.copyWith(p3DriverId: newP3DriverId);
          return listener(
            AsyncData<GrandPrixBetNotifierState?>(previousState),
            AsyncData<GrandPrixBetNotifierState?>(state),
          );
        },
        () {
          final previousState = state;
          state = state.copyWith(p10DriverId: newP10DriverId);
          listener(
            AsyncData<GrandPrixBetNotifierState?>(previousState),
            AsyncData<GrandPrixBetNotifierState?>(state),
          );
        },
        () {
          final previousState = state;
          state = state.copyWith(fastestLapDriverId: newFastestLapDriverId);
          return listener(
            AsyncData<GrandPrixBetNotifierState?>(previousState),
            AsyncData<GrandPrixBetNotifierState?>(state),
          );
        },
        () {
          final previousState = state;
          state = state.copyWith(dnfDriverIds: newDnfDriverIds);
          return listener(
            AsyncData<GrandPrixBetNotifierState?>(previousState),
            AsyncData<GrandPrixBetNotifierState?>(state),
          );
        },
        () {
          final previousState = state;
          state = state.copyWith(willBeSafetyCar: newWillBeSafetyCar);
          return listener(
            AsyncData<GrandPrixBetNotifierState?>(previousState),
            AsyncData<GrandPrixBetNotifierState?>(state),
          );
        },
        () {
          final previousState = state;
          state = state.copyWith(willBeRedFlag: newWillBeRedFlag);
          return listener(
            AsyncData<GrandPrixBetNotifierState?>(previousState),
            AsyncData<GrandPrixBetNotifierState?>(state),
          );
        },
        () {
          final previousState = state;
          state = state.copyWith(
            status: const GrandPrixBetNotifierStatusSavingData(),
          );
          return listener(
            AsyncData<GrandPrixBetNotifierState?>(previousState),
            AsyncData<GrandPrixBetNotifierState?>(state),
          );
        },
        () {
          final previousState = state;
          state = state.copyWith(
            status: const GrandPrixBetNotifierStatusDataSaved(),
          );
          return listener(
            AsyncData<GrandPrixBetNotifierState?>(previousState),
            AsyncData<GrandPrixBetNotifierState?>(state),
          );
        },
      ]);
      verifyNoMoreInteractions(listener);
      verify(
        () => grandPrixBetRepository.updateGrandPrixBet(
          userId: loggedUserId,
          grandPrixBetId: grandPrixBetId,
          qualiStandingsByDriverIds: newStandings,
          p1DriverId: newP1DriverId,
          p2DriverId: newP2DriverId,
          p3DriverId: newP3DriverId,
          p10DriverId: newP10DriverId,
          fastestLapDriverId: newFastestLapDriverId,
          dnfDriverIds: newDnfDriverIds,
          willBeSafetyCar: newWillBeSafetyCar,
          willBeRedFlag: newWillBeRedFlag,
        ),
      ).called(1);
    },
  );
}
