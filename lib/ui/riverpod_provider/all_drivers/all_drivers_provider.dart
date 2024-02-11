import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repository/driver/driver_repository.dart';
import '../../../model/driver.dart';

part 'all_drivers_provider.g.dart';

@riverpod
Future<List<Driver>?> allDrivers(AllDriversRef ref) async =>
    ref.watch(driverRepositoryProvider).loadAllDrivers();
