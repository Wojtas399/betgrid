import 'package:collection/collection.dart';

import '../../../dependency_injection.dart';
import '../../../firebase/model/driver_dto/driver_dto.dart';
import '../../../firebase/service/firebase_driver_service.dart';
import '../../../model/driver.dart';
import '../../mapper/driver_mapper.dart';
import '../repository.dart';
import 'driver_repository.dart';

class DriverRepositoryImpl extends Repository<Driver>
    implements DriverRepository {
  final FirebaseDriverService _dbDriverService;

  DriverRepositoryImpl({super.initialData})
      : _dbDriverService = getIt<FirebaseDriverService>();

  @override
  Stream<Driver?> getDriverById({required String driverId}) async* {
    await for (final drivers in repositoryState$) {
      Driver? driver = drivers?.firstWhereOrNull(
        (driver) => driver.id == driverId,
      );
      driver ??= await _loadDriverFromDb(driverId);
      yield driver;
    }
  }

  Future<Driver?> _loadDriverFromDb(String driverId) async {
    final DriverDto? driverDto = await _dbDriverService.loadDriverById(
      driverId: driverId,
    );
    if (driverDto == null) return null;
    final Driver driver = mapDriverFromDto(driverDto);
    addEntity(driver);
    return driver;
  }
}
