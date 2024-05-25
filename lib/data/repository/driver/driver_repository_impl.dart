import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../firebase/model/driver_dto/driver_dto.dart';
import '../../../firebase/service/firebase_driver_service.dart';
import '../../../model/driver.dart';
import '../../mapper/driver_mapper.dart';
import '../repository.dart';
import 'driver_repository.dart';

@LazySingleton(as: DriverRepository)
class DriverRepositoryImpl extends Repository<Driver>
    implements DriverRepository {
  final FirebaseDriverService _dbDriverService;

  DriverRepositoryImpl(this._dbDriverService);

  @override
  Stream<List<Driver>> getAllDrivers() async* {
    if (isRepositoryStateEmpty) await _fetchAllDriversFromDb();
    await for (final allDrivers in repositoryState$) {
      yield allDrivers;
    }
  }

  @override
  Stream<Driver?> getDriverById({required String driverId}) async* {
    await for (final drivers in repositoryState$) {
      Driver? driver = drivers.firstWhereOrNull(
        (driver) => driver.id == driverId,
      );
      driver ??= await _fetchDriverFromDb(driverId);
      yield driver;
    }
  }

  Future<void> _fetchAllDriversFromDb() async {
    final List<DriverDto> driverDtos = await _dbDriverService.fetchAllDrivers();
    final List<Driver> drivers = driverDtos.map(mapDriverFromDto).toList();
    setEntities(drivers);
  }

  Future<Driver?> _fetchDriverFromDb(String driverId) async {
    final DriverDto? driverDto = await _dbDriverService.fetchDriverById(
      driverId: driverId,
    );
    if (driverDto == null) return null;
    final Driver driver = mapDriverFromDto(driverDto);
    addEntity(driver);
    return driver;
  }
}
