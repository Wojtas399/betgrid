import 'package:betgrid_shared/firebase/model/driver_personal_data_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_driver_personal_data_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/driver_personal_data.dart';
import '../../mapper/driver_personal_data_mapper.dart';
import '../repository.dart';
import 'driver_personal_data_repository.dart';

@LazySingleton(as: DriverPersonalDataRepository)
class DriverPersonalDataRepositoryImpl extends Repository<DriverPersonalData>
    implements DriverPersonalDataRepository {
  final FirebaseDriverPersonalDataService _firebaseDriverPersonalDataService;
  final DriverPersonalDataMapper _driverPersonalDataMapper;
  final _getByIdMutex = Mutex();

  DriverPersonalDataRepositoryImpl(
    this._firebaseDriverPersonalDataService,
    this._driverPersonalDataMapper,
  );

  @override
  Stream<List<DriverPersonalData>> getAll() async* {
    await _fetchAll();
    await for (final allDriversPersonalData in repositoryState$) {
      yield allDriversPersonalData;
    }
  }

  @override
  Stream<DriverPersonalData?> getById(String id) async* {
    bool didRelease = false;
    await _getByIdMutex.acquire();
    await for (final allDriversPersonalData in repositoryState$) {
      DriverPersonalData? matchingDriverPersonalData = allDriversPersonalData
          .firstWhereOrNull(
            (driverPersonalData) => driverPersonalData.id == id,
          );
      matchingDriverPersonalData ??= await _fetchById(id);
      if (_getByIdMutex.isLocked && !didRelease) {
        _getByIdMutex.release();
        didRelease = true;
      }
      yield matchingDriverPersonalData;
    }
  }

  @override
  Future<void> add({required String name, required String surname}) async {
    final DriverPersonalDataDto? addedDriverPersonalDataDto =
        await _firebaseDriverPersonalDataService.add(
          name: name,
          surname: surname,
        );
    if (addedDriverPersonalDataDto != null) {
      final DriverPersonalData addedDriverPersonalData =
          _driverPersonalDataMapper.mapFromDto(addedDriverPersonalDataDto);
      addEntity(addedDriverPersonalData);
    }
  }

  @override
  Future<void> deleteById(String id) async {
    await _firebaseDriverPersonalDataService.deleteById(id);
    deleteEntity(id);
  }

  Future<void> _fetchAll() async {
    final allDriversPersonalDataDtos =
        await _firebaseDriverPersonalDataService.fetchAll();
    if (allDriversPersonalDataDtos.isNotEmpty) {
      final allDriversPersonalData = allDriversPersonalDataDtos.map(
        _driverPersonalDataMapper.mapFromDto,
      );
      addOrUpdateEntities(allDriversPersonalData);
    }
  }

  Future<DriverPersonalData?> _fetchById(String id) async {
    final driverPersonalDataDto = await _firebaseDriverPersonalDataService
        .fetchById(id);
    if (driverPersonalDataDto == null) return null;
    final driverPersonalData = _driverPersonalDataMapper.mapFromDto(
      driverPersonalDataDto,
    );
    addEntity(driverPersonalData);
    return driverPersonalData;
  }
}
