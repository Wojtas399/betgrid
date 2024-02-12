import 'package:betgrid/data/repository/driver/driver_repository.dart';
import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/riverpod_provider/all_drivers_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/driver_creator.dart';
import '../../mock/data/repository/mock_driver_repository.dart';
import '../../mock/listener.dart';

void main() {
  final driverRepository = MockDriverRepository();

  ProviderContainer makeProviderContainer(
    MockDriverRepository driverRepository,
  ) {
    final container = ProviderContainer(overrides: [
      driverRepositoryProvider.overrideWithValue(driverRepository),
    ]);
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(driverRepository);
  });

  test(
    'should load and return all drivers from DriverRepository',
    () async {
      final List<Driver> allDrivers = [
        createDriver(id: 'd1'),
        createDriver(id: 'd2'),
        createDriver(id: 'd3'),
      ];
      driverRepository.mockLoadAllDrivers(allDrivers);
      final container = makeProviderContainer(driverRepository);
      final listener = Listener<AsyncValue<List<Driver>?>>();
      container.listen(
        allDriversProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(allDriversProvider.future),
        completion(allDrivers),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<List<Driver>?>(),
            ),
        () => listener(
              const AsyncLoading<List<Driver>?>(),
              AsyncData<List<Driver>?>(allDrivers),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(driverRepository.loadAllDrivers).called(1);
    },
  );
}
