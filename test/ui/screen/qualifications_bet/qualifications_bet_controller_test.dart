import 'package:betgrid/data/repository/driver/driver_repository.dart';
import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/screen/qualifications_bet/controller/qualifications_bet_controller.dart';
import 'package:betgrid/ui/screen/qualifications_bet/state/qualifications_bet_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';
import '../../../mock/listener.dart';

void main() {
  final driverRepository = MockDriverRepository();

  ProviderContainer makeProviderContainer(
    MockDriverRepository driverRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        driverRepositoryProvider.overrideWithValue(driverRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(driverRepository);
  });

  test(
    'build, '
    'should load all drivers from DriverRepository and '
    'should emit them in QualificationsBetStateDataLoaded',
    () async {
      final List<Driver> drivers = [
        createDriver(id: 'd1'),
        createDriver(id: 'd2'),
      ];
      driverRepository.mockGetAllDrivers(drivers);
      final container = makeProviderContainer(driverRepository);
      final listener = Listener<AsyncValue<QualificationsBetState>>();
      container.listen(
        qualificationsBetControllerProvider,
        listener,
        fireImmediately: true,
      );
      final controller =
          container.read(qualificationsBetControllerProvider.notifier);

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<QualificationsBetState>(),
            ),
        () => listener(
              const AsyncLoading<QualificationsBetState>(),
              AsyncData<QualificationsBetState>(
                QualificationsBetStateDataLoaded(drivers: drivers),
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(driverRepository.getAllDrivers).called(1);
    },
  );
}
