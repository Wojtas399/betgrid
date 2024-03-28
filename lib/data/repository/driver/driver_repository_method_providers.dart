import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/driver.dart';
import 'driver_repository.dart';

part 'driver_repository_method_providers.g.dart';

@riverpod
Stream<Driver?> driver(
  DriverRef ref, {
  required String driverId,
}) =>
    ref.watch(driverRepositoryProvider).getDriverById(driverId: driverId);
