import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/ui/provider/grand_prix_bet_status_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_bet_creator.dart';
import '../../mock/auth/mock_auth_service.dart';
import '../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  const String grandPrixId = 'gp1';
  const String loggedUserId = 'u1';

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
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
  });

  tearDown(() {
    reset(authService);
    reset(grandPrixBetRepository);
  });

  test(
    'all required bet params are null, '
    'should return pending status',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(),
      );
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBetStatus?>>();
      container.listen(
        grandPrixBetStatusProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetStatusProvider(grandPrixId).future),
        completion(GrandPrixBetStatus.pending),
      );
    },
  );

  test(
    'all required bet params are not null, '
    'should return completed status',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          qualiStandingsByDriverIds: List.generate(20, (_) => 'd1'),
          p1DriverId: 'd1',
          p2DriverId: 'd2',
          p3DriverId: 'd3',
          p10DriverId: 'd10',
          fastestLapDriverId: 'd1',
          dnfDriverIds: ['d1', 'd2', 'd3'],
          willBeSafetyCar: true,
          willBeRedFlag: false,
        ),
      );
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBetStatus?>>();
      container.listen(
        grandPrixBetStatusProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetStatusProvider(grandPrixId).future),
        completion(GrandPrixBetStatus.completed),
      );
    },
  );

  test(
    'at least one element in qualiStandings is null, '
    'should return inProgress status',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          qualiStandingsByDriverIds: List.generate(
            20,
            (index) => index == 0 ? null : 'd1',
          ),
          p1DriverId: 'd1',
          p2DriverId: 'd2',
          p3DriverId: 'd3',
          p10DriverId: 'd10',
          fastestLapDriverId: 'd1',
          dnfDriverIds: ['d1', 'd2', 'd3'],
          willBeSafetyCar: true,
          willBeRedFlag: false,
        ),
      );
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBetStatus?>>();
      container.listen(
        grandPrixBetStatusProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetStatusProvider(grandPrixId).future),
        completion(GrandPrixBetStatus.inProgress),
      );
    },
  );

  test(
    'p1DriverId is null, '
    'should return inProgress status',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          qualiStandingsByDriverIds: List.generate(20, (_) => 'd1'),
          p2DriverId: 'd2',
          p3DriverId: 'd3',
          p10DriverId: 'd10',
          fastestLapDriverId: 'd1',
          dnfDriverIds: ['d1', 'd2', 'd3'],
          willBeSafetyCar: true,
          willBeRedFlag: false,
        ),
      );
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBetStatus?>>();
      container.listen(
        grandPrixBetStatusProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetStatusProvider(grandPrixId).future),
        completion(GrandPrixBetStatus.inProgress),
      );
    },
  );

  test(
    'p2DriverId is null, '
    'should return inProgress status',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          qualiStandingsByDriverIds: List.generate(20, (_) => 'd1'),
          p1DriverId: 'd2',
          p3DriverId: 'd3',
          p10DriverId: 'd10',
          fastestLapDriverId: 'd1',
          dnfDriverIds: ['d1', 'd2', 'd3'],
          willBeSafetyCar: true,
          willBeRedFlag: false,
        ),
      );
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBetStatus?>>();
      container.listen(
        grandPrixBetStatusProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetStatusProvider(grandPrixId).future),
        completion(GrandPrixBetStatus.inProgress),
      );
    },
  );

  test(
    'p3DriverId is null, '
    'should return inProgress status',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          qualiStandingsByDriverIds: List.generate(20, (_) => 'd1'),
          p1DriverId: 'd2',
          p2DriverId: 'd3',
          p10DriverId: 'd10',
          fastestLapDriverId: 'd1',
          dnfDriverIds: ['d1', 'd2', 'd3'],
          willBeSafetyCar: true,
          willBeRedFlag: false,
        ),
      );
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBetStatus?>>();
      container.listen(
        grandPrixBetStatusProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetStatusProvider(grandPrixId).future),
        completion(GrandPrixBetStatus.inProgress),
      );
    },
  );

  test(
    'p10DriverId is null, '
    'should return inProgress status',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          qualiStandingsByDriverIds: List.generate(20, (_) => 'd1'),
          p1DriverId: 'd2',
          p2DriverId: 'd3',
          p3DriverId: 'd10',
          fastestLapDriverId: 'd1',
          dnfDriverIds: ['d1', 'd2', 'd3'],
          willBeSafetyCar: true,
          willBeRedFlag: false,
        ),
      );
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBetStatus?>>();
      container.listen(
        grandPrixBetStatusProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetStatusProvider(grandPrixId).future),
        completion(GrandPrixBetStatus.inProgress),
      );
    },
  );

  test(
    'fastestLapDriverId is null, '
    'should return inProgress status',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          qualiStandingsByDriverIds: List.generate(20, (_) => 'd1'),
          p1DriverId: 'd2',
          p2DriverId: 'd3',
          p3DriverId: 'd10',
          p10DriverId: 'd1',
          dnfDriverIds: ['d1', 'd2', 'd3'],
          willBeSafetyCar: true,
          willBeRedFlag: false,
        ),
      );
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBetStatus?>>();
      container.listen(
        grandPrixBetStatusProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetStatusProvider(grandPrixId).future),
        completion(GrandPrixBetStatus.inProgress),
      );
    },
  );

  test(
    'at least one element in dnDriverIds is null, '
    'should return inProgress status',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          qualiStandingsByDriverIds: List.generate(20, (_) => 'd1'),
          p1DriverId: 'd2',
          p2DriverId: 'd3',
          p3DriverId: 'd10',
          p10DriverId: 'd1',
          fastestLapDriverId: 'd3',
          dnfDriverIds: ['d1', null, 'd3'],
          willBeSafetyCar: true,
          willBeRedFlag: false,
        ),
      );
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBetStatus?>>();
      container.listen(
        grandPrixBetStatusProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetStatusProvider(grandPrixId).future),
        completion(GrandPrixBetStatus.inProgress),
      );
    },
  );

  test(
    'willBeSafetyCar is null, '
    'should return inProgress status',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          qualiStandingsByDriverIds: List.generate(20, (_) => 'd1'),
          p1DriverId: 'd2',
          p2DriverId: 'd3',
          p3DriverId: 'd10',
          p10DriverId: 'd1',
          fastestLapDriverId: 'd3',
          dnfDriverIds: ['d1', 'd2', 'd3'],
          willBeRedFlag: false,
        ),
      );
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBetStatus?>>();
      container.listen(
        grandPrixBetStatusProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetStatusProvider(grandPrixId).future),
        completion(GrandPrixBetStatus.inProgress),
      );
    },
  );

  test(
    'willBeRedFlag is null, '
    'should return inProgress status',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          qualiStandingsByDriverIds: List.generate(20, (_) => 'd1'),
          p1DriverId: 'd2',
          p2DriverId: 'd3',
          p3DriverId: 'd10',
          p10DriverId: 'd1',
          fastestLapDriverId: 'd3',
          dnfDriverIds: ['d1', 'd2', 'd3'],
          willBeSafetyCar: false,
        ),
      );
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBetStatus?>>();
      container.listen(
        grandPrixBetStatusProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetStatusProvider(grandPrixId).future),
        completion(GrandPrixBetStatus.inProgress),
      );
    },
  );
}
