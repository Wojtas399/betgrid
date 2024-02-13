import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/ui/riverpod_provider/grand_prix_id_provider.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/notifier/grand_prix_bet_notifier.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/notifier/grand_prix_bet_notifier_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../mock/auth/mock_auth_service.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  const String loggedUserId = 'u1';
  const String grandPrixId = 'gp1';
  late Listener<AsyncValue<GrandPrixBetNotifierState?>> listener;

  ProviderContainer makeProviderContainer(
    String grandPrixId,
    MockAuthService authService,
    MockGrandPrixBetRepository grandPrixBetRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
        authServiceProvider.overrideWithValue(authService),
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
    grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
      createGrandPrixBet(grandPrixId: grandPrixId),
    );
    listener = Listener<AsyncValue<GrandPrixBetNotifierState?>>();
  });

  tearDown(() {
    reset(authService);
    reset(grandPrixBetRepository);
  });

  test(
    'build, '
    'should watch to grand prix bet and emit its bet values',
    () async {
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
      );
      final GrandPrixBetNotifierState expectedState = GrandPrixBetNotifierState(
        qualiStandingsByDriverIds: grandPrixBet.qualiStandingsByDriverIds,
        p1DriverId: grandPrixBet.p1DriverId,
        p2DriverId: grandPrixBet.p2DriverId,
        p3DriverId: grandPrixBet.p3DriverId,
        p10DriverId: grandPrixBet.p10DriverId,
        fastestLapDriverId: grandPrixBet.fastestLapDriverId,
      );
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(grandPrixBet);
      final container = makeProviderContainer(
        grandPrixId,
        authService,
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
    'onPositionDriverChanged, '
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
          qualiStandingsByDriverIds: List.generate(20, (_) => null),
        ),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
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
      notifier.onPositionDriverChanged(index, driverId);

      await expectLater(
        container.read(grandPrixBetNotifierProvider.future),
        completion(GrandPrixBetNotifierState(
          qualiStandingsByDriverIds: expectedList,
        )),
      );
    },
  );

  test(
    'onP1DriverChanged, '
    'should update p1 driver id in state',
    () async {
      const String p1DriverId = 'd1';
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
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
          qualiStandingsByDriverIds: List.generate(20, (_) => null),
          p1DriverId: p1DriverId,
        )),
      );
    },
  );

  test(
    'onP2DriverChanged, '
    'should update p2 driver id in state',
    () async {
      const String p2DriverId = 'd1';
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
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
          qualiStandingsByDriverIds: List.generate(20, (_) => null),
          p2DriverId: p2DriverId,
        )),
      );
    },
  );

  test(
    'onP3DriverChanged, '
    'should update p3 driver id in state',
    () async {
      const String p3DriverId = 'd1';
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
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
          qualiStandingsByDriverIds: List.generate(20, (_) => null),
          p3DriverId: p3DriverId,
        )),
      );
    },
  );

  test(
    'onFastestLapDriverChanged, '
    'should update fastest lap driver id in state',
    () async {
      const String fastestLapDriverId = 'd1';
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
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
          qualiStandingsByDriverIds: List.generate(20, (_) => null),
          fastestLapDriverId: fastestLapDriverId,
        )),
      );
    },
  );

  test(
    'saveStandings, '
    'should should call method from GrandPrixBetRepository to update bet with '
    'new qualifications standings, p1DriverId, p2DriverId, p3DriverId, '
    'p10DriverId and fastestLapDriverId',
    () async {
      const String grandPrixBetId = 'gpb1';
      final List<String?> standings = List.generate(20, (_) => null);
      final List<String?> newStandings = List.generate(
        20,
        (index) => switch (index) {
          1 => 'd4',
          5 => 'd9',
          11 => 'd1',
          _ => null,
        },
      );
      String newP1DriverId = 'd1';
      String newP2DriberId = 'd2';
      String newP3DriverId = 'd3';
      String newP10DriverId = 'd10';
      String newFastestLapDriverId = 'd11';
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(
          id: grandPrixBetId,
          qualiStandingsByDriverIds: standings,
        ),
      );
      grandPrixBetRepository.mockUpdateGrandPrixBet();
      final container = makeProviderContainer(
        grandPrixId,
        authService,
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
      notifier.onPositionDriverChanged(1, 'd4');
      notifier.onPositionDriverChanged(5, 'd9');
      notifier.onPositionDriverChanged(11, 'd1');
      notifier.onP1DriverChanged(newP1DriverId);
      notifier.onP2DriverChanged(newP2DriberId);
      notifier.onP3DriverChanged(newP3DriverId);
      notifier.onP10DriverChanged(newP10DriverId);
      notifier.onFastestLapDriverChanged(newFastestLapDriverId);
      await notifier.saveStandings();

      verify(
        () => grandPrixBetRepository.updateGrandPrixBet(
          userId: loggedUserId,
          grandPrixBetId: grandPrixBetId,
          qualiStandingsByDriverIds: newStandings,
          p1DriverId: newP1DriverId,
          p2DriverId: newP2DriberId,
          p3DriverId: newP3DriverId,
          p10DriverId: newP10DriverId,
          fastestLapDriverId: newFastestLapDriverId,
        ),
      ).called(1);
    },
  );
}
