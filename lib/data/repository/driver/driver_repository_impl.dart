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
  Stream<List<Driver>?> getAllDrivers() async* {
    if (isRepositoryStateNotInitialized || isRepositoryStateEmpty) {
      await _loadAllDriversFromDb();
    }
    await for (final drivers in repositoryState$) {
      yield drivers;
    }
  }

  Future<void> _loadAllDriversFromDb() async {
    final List<DriverDto> driverDtos = await _dbDriverService.loadAllDrivers();
    final List<Driver> drivers = driverDtos.map(mapDriverFromDto).toList();
    setEntities(drivers);
  }
}
