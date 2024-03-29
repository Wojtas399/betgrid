import 'package:betgrid/data/repository/driver/driver_repository.dart';
import 'package:betgrid/data/repository/driver/driver_repository_method_providers.dart';
import 'package:betgrid/model/driver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/driver_creator.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';

void main() {
  final driverRepository = MockDriverRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        driverRepositoryProvider.overrideWithValue(driverRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'allDriversProvider, '
    'should get all drivers from DriverRepository and should emit them',
    () async {
      final List<Driver> expectedAllDrivers = [
        createDriver(id: 'd1'),
        createDriver(id: 'd2'),
        createDriver(id: 'd3'),
      ];
      driverRepository.mockGetAllDrivers(allDrivers: expectedAllDrivers);
      final container = makeProviderContainer();

      final List<Driver> allDrivers = await container.read(
        allDriversProvider.future,
      );

      expect(allDrivers, expectedAllDrivers);
    },
  );

  test(
    'driverProvider, '
    'should get driver from DriverRepository and should emit it',
    () async {
      const String driverId = 'd1';
      const Driver expectedDriver = Driver(
        id: driverId,
        name: 'name',
        surname: 'surname',
        number: 1,
        team: Team.redBullRacing,
      );
      driverRepository.mockGetDriverById(driver: expectedDriver);
      final container = makeProviderContainer();

      final Driver? driver = await container.read(
        driverProvider(driverId: driverId).future,
      );

      expect(driver, expectedDriver);
    },
  );
}