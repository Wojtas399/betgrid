import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/driver/driver_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/screen/qualifications_bet/controller/qualifications_bet_controller.dart';
import 'package:betgrid/ui/screen/qualifications_bet/state/qualifications_bet_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/grand_prix_bet_creator.dart';
import '../../../mock/auth/mock_auth_service.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final driverRepository = MockDriverRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();

  ProviderContainer makeProviderContainer(
    MockAuthService authService,
    MockDriverRepository driverRepository,
    MockGrandPrixBetRepository grandPrixBetRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(authService),
        driverRepositoryProvider.overrideWithValue(driverRepository),
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
    'should load all drivers from DriverRepository and '
    'should load grand prix bet from GrandPrixBetRepository and '
    'should emit drivers and qualifications standings in QualificationsBetStateDataLoaded state',
    () async {
      const String loggedUserId = 'u1';
      const String grandPrixId = 'gp1';
      final List<Driver> drivers = [
        createDriver(id: 'd1'),
        createDriver(id: 'd2'),
        createDriver(id: 'd3'),
      ];
      final List<String> qualiStandingsByDriverIds = ['d2', 'd1', 'd3'];
      authService.mockGetLoggedUserId(loggedUserId);
      driverRepository.mockGetAllDrivers(drivers);
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(
          grandPrixId: grandPrixId,
          qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        ),
      );
      final container = makeProviderContainer(
        authService,
        driverRepository,
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
                  drivers: drivers,
                  qualiStandingsByDriverIds: qualiStandingsByDriverIds,
                ),
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(driverRepository.getAllDrivers).called(1);
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: loggedUserId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );
}
