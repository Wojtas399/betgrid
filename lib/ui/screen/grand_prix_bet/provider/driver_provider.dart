import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../model/driver.dart';

part 'driver_provider.g.dart';

@riverpod
Stream<Driver?> driver(DriverRef ref, {required String driverId}) =>
    ref.watch(driverRepositoryProvider).getDriverById(driverId: driverId);
