import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/driver_personal_data.dart';
import '../../firebase/model/driver_personal_data_dto.dart';
import '../../firebase/service/firebase_driver_personal_data_service.dart';
import '../../mapper/driver_personal_data_mapper.dart';
import '../repository.dart';
import 'driver_personal_data_repository.dart';

@LazySingleton(as: DriverPersonalDataRepository)
class DriverPersonalDataRepositoryImpl extends Repository<DriverPersonalData>
    implements DriverPersonalDataRepository {
  final FirebaseDriverPersonalDataService _firebaseDriverPersonalDataService;
  final DriverPersonalDataMapper _driverPersonalDataMapper;
  final _getDriverPersonalDataByIdMutex = Mutex();

  DriverPersonalDataRepositoryImpl(
    this._firebaseDriverPersonalDataService,
    this._driverPersonalDataMapper,
  );

  @override
  Stream<DriverPersonalData?> getDriverPersonalDataById(String id) async* {
    await _getDriverPersonalDataByIdMutex.acquire();
    await for (final driversPersonalData in repositoryState$) {
      DriverPersonalData? matchingDriver = driversPersonalData.firstWhereOrNull(
        (driverPersonalData) => driverPersonalData.id == id,
      );
      matchingDriver ??= await _fetchDriverPersonalDataById(id);
      if (_getDriverPersonalDataByIdMutex.isLocked) {
        _getDriverPersonalDataByIdMutex.release();
      }
      yield matchingDriver;
    }
  }

  Future<DriverPersonalData?> _fetchDriverPersonalDataById(String id) async {
    final DriverPersonalDataDto? dto = await _firebaseDriverPersonalDataService
        .fetchDriverPersonalDataById(id);
    if (dto == null) return null;
    final DriverPersonalData driverPersonalData =
        _driverPersonalDataMapper.mapFromDto(dto);
    addEntity(driverPersonalData);
    return driverPersonalData;
  }
}
