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
  Stream<List<Driver>> getAllDrivers() async* {
    await for (final repoState in repositoryState$) {
      List<Driver>? allDrivers = repoState;
      if (allDrivers == null || allDrivers.isEmpty) {
        allDrivers = await _fetchAllDriversFromDb();
      }
      yield allDrivers;
    }
  }

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

  Future<List<Driver>> _fetchAllDriversFromDb() async {
    final List<DriverDto> driverDtos = await _dbDriverService.fetchAllDrivers();
    final List<Driver> drivers = driverDtos.map(mapDriverFromDto).toList();
    setEntities(drivers);
    return drivers;
  }

  Future<Driver?> _loadDriverFromDb(String driverId) async {
    final DriverDto? driverDto = await _dbDriverService.fetchDriverById(
      driverId: driverId,
    );
    if (driverDto == null) return null;
    final Driver driver = mapDriverFromDto(driverDto);
    addEntity(driver);
    return driver;
  }
}
