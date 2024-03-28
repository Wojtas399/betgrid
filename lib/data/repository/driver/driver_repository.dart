import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/driver.dart';
import 'driver_repository_impl.dart';

part 'driver_repository.g.dart';

abstract interface class DriverRepository {
  Stream<Driver?> getDriverById({required String driverId});
}

@riverpod
DriverRepository driverRepository(DriverRepositoryRef ref) =>
    DriverRepositoryImpl();
