import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../dependency_injection.dart';
import '../../../firebase/service/firebase_driver_service.dart';
import '../../../model/driver.dart';
import 'driver_repository_impl.dart';

part 'driver_repository.g.dart';

abstract interface class DriverRepository {
  Stream<List<Driver>> getAllDrivers();

  Stream<Driver?> getDriverById({required String driverId});
}

@Riverpod(keepAlive: true)
DriverRepository driverRepository(DriverRepositoryRef ref) =>
    DriverRepositoryImpl(getIt.get<FirebaseDriverService>());
