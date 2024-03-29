import 'package:betgrid/data/repository/driver/driver_repository.dart';
import 'package:betgrid/model/driver.dart';
import 'package:mocktail/mocktail.dart';

class MockDriverRepository extends Mock implements DriverRepository {
  void mockGetAllDrivers({required List<Driver> allDrivers}) {
    when(getAllDrivers).thenAnswer((_) => Stream.value(allDrivers));
  }

  void mockGetDriverById({Driver? driver}) {
    when(
      () => getDriverById(
        driverId: any(named: 'driverId'),
      ),
    ).thenAnswer((_) => Stream.value(driver));
  }
}
