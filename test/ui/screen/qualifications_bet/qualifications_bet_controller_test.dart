import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/driver/driver_repository.dart';
import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/driver.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/screen/qualifications_bet/controller/qualifications_bet_controller.dart';
import 'package:betgrid/ui/screen/qualifications_bet/state/qualifications_bet_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../mock/auth/mock_auth_service.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final driverRepository = MockDriverRepository();
  final grandPrixRepository = MockGrandPrixRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();

  ProviderContainer makeProviderContainer(
    MockAuthService authService,
    MockDriverRepository driverRepository,
    MockGrandPrixRepository grandPrixRepository,
    MockGrandPrixBetRepository grandPrixBetRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(authService),
        driverRepositoryProvider.overrideWithValue(driverRepository),
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
    reset(driverRepository);
    reset(grandPrixRepository);
    reset(grandPrixBetRepository);
  });

  test(
    'build, '
    'logged user not found, '
    'should emit QualificationsBetStateLoggedUserNotFound state',
    () async {
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(
        authService,
        driverRepository,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      final listener = Listener<AsyncValue<QualificationsBetState>>();
      container.listen(
        qualificationsBetControllerProvider('gp1'),
        listener,
        fireImmediately: true,
      );
      final controller = container.read(
        qualificationsBetControllerProvider('gp1').notifier,
      );

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<QualificationsBetState>(),
            ),
        () => listener(
              const AsyncLoading<QualificationsBetState>(),
              const AsyncData<QualificationsBetState>(
                QualificationsBetStateLoggedUserNotFound(),
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'build, '
    'should load grand prix from GrandPrixRepository and '
    'should load all drivers from DriverRepository and '
    'should load grand prix bet from GrandPrixBetRepository and '
    'should emit grand prix name, drivers and qualifications standings in '
    'QualificationsBetStateDataLoaded state',
    () async {
      const String loggedUserId = 'u1';
      const String grandPrixId = 'gp1';
      final GrandPrix grandPrix = createGrandPrix(
        id: grandPrixId,
        name: 'grand prix 1',
      );
      final List<Driver> drivers = [
        createDriver(id: 'd1'),
        createDriver(id: 'd2'),
        createDriver(id: 'd3'),
      ];
      final List<String> qualiStandingsByDriverIds = ['d2', 'd1', 'd3'];
      authService.mockGetLoggedUserId(loggedUserId);
      driverRepository.mockLoadAllDrivers(drivers);
      grandPrixRepository.mockLoadGrandPrixById(grandPrix);
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(
          grandPrixId: grandPrixId,
          qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        ),
      );
      final container = makeProviderContainer(
        authService,
        driverRepository,
        grandPrixRepository,
        grandPrixBetRepository,
      );
      final listener = Listener<AsyncValue<QualificationsBetState>>();
      container.listen(
        qualificationsBetControllerProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );
      final controller = container.read(
        qualificationsBetControllerProvider(grandPrixId).notifier,
      );

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<QualificationsBetState>(),
            ),
        () => listener(
              const AsyncLoading<QualificationsBetState>(),
              AsyncData<QualificationsBetState>(
                QualificationsBetStateDataLoaded(
                  gpName: grandPrix.name,
                  drivers: drivers,
                  qualiStandingsByDriverIds: qualiStandingsByDriverIds,
                ),
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(driverRepository.loadAllDrivers).called(1);
      verify(
        () => grandPrixRepository.loadGrandPrixById(grandPrixId: grandPrixId),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: loggedUserId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );
}
