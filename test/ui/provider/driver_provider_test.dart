import 'package:betgrid/data/repository/driver/driver_repository.dart';
import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/provider/driver_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/data/repository/mock_driver_repository.dart';
import '../../mock/listener.dart';

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

  tearDown(() {
    reset(driverRepository);
  });

  test(
    'should emit driver got directly from driver repository',
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
      final listener = Listener<AsyncValue<Driver?>>();
      container.listen(
        driverProvider(driverId: driverId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(driverProvider(driverId: driverId).future),
        completion(expectedDriver),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<Driver?>(),
            ),
        () => listener(
              const AsyncLoading<Driver?>(),
              const AsyncData<Driver?>(expectedDriver),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(
        () => driverRepository.getDriverById(
          driverId: driverId,
        ),
      ).called(1);
    },
  );
}
