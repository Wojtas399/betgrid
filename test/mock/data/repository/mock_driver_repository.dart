import 'package:betgrid/data/repository/driver/driver_repository.dart';
import 'package:betgrid/model/driver.dart';
import 'package:mocktail/mocktail.dart';

class MockDriverRepository extends Mock implements DriverRepository {
  void mockLoadAllDrivers(List<Driver>? drivers) {
    when(loadAllDrivers).thenAnswer((_) => Future.value(drivers));
  }
}
