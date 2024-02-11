import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/driver.dart';
import 'driver_repository_impl.dart';

part 'driver_repository.g.dart';

@riverpod
DriverRepository driverRepository(DriverRepositoryRef ref) =>
    DriverRepositoryImpl();

abstract interface class DriverRepository {
  Future<List<Driver>?> loadAllDrivers();
}
