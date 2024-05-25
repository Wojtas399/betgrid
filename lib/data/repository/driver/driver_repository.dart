import '../../../model/driver.dart';

abstract interface class DriverRepository {
  Stream<List<Driver>> getAllDrivers();

  Stream<Driver?> getDriverById({required String driverId});
}
