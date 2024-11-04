import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/season_driver.dart';
import '../../firebase/service/firebase_season_driver_service.dart';
import '../../mapper/season_driver_mapper.dart';
import '../repository.dart';
import 'season_driver_repository.dart';

@LazySingleton(as: SeasonDriverRepository)
class SeasonDriverRepositoryImpl extends Repository<SeasonDriver>
    implements SeasonDriverRepository {
  final FirebaseSeasonDriverService _firebaseSeasonDriverService;
  final SeasonDriverMapper _seasonDriverMapper;
  final _getAllSeasonDriversMutex = Mutex();
  final _getSeasonDriverByDriverIdAndSeasonMutex = Mutex();

  SeasonDriverRepositoryImpl(
    this._firebaseSeasonDriverService,
    this._seasonDriverMapper,
  );

  @override
  Stream<List<SeasonDriver>> getAllSeasonDriversFromSeason(int season) async* {
    await _getAllSeasonDriversMutex.acquire();
    await _fetchAllSeasonDriversFromSeason(season);
    await for (final allSeasonDrivers in repositoryState$) {
      if (_getAllSeasonDriversMutex.isLocked) {
        _getAllSeasonDriversMutex.release();
      }
      yield allSeasonDrivers
          .where((seasonDriver) => seasonDriver.season == season)
          .toList();
    }
  }

  @override
  Stream<SeasonDriver?> getSeasonDriverById(String id) async* {
    await _getSeasonDriverByDriverIdAndSeasonMutex.acquire();
    await for (final allSeasonDrivers in repositoryState$) {
      SeasonDriver? matchingSeasonDriver = allSeasonDrivers.firstWhereOrNull(
        (seasonDriver) => seasonDriver.id == id,
      );
      matchingSeasonDriver ??= await _fetchSeasonDriverById(id);
      if (_getSeasonDriverByDriverIdAndSeasonMutex.isLocked) {
        _getSeasonDriverByDriverIdAndSeasonMutex.release();
      }
      yield matchingSeasonDriver;
    }
  }

  Future<void> _fetchAllSeasonDriversFromSeason(int season) async {
    final seasonDriverDtos = await _firebaseSeasonDriverService
        .fetchAllSeasonDriversFromSeason(season);
    if (seasonDriverDtos.isNotEmpty) {
      final seasonDrivers =
          seasonDriverDtos.map(_seasonDriverMapper.mapFromDto);
      addOrUpdateEntities(seasonDrivers);
    }
  }

  Future<SeasonDriver?> _fetchSeasonDriverById(String id) async {
    final seasonDriverDto =
        await _firebaseSeasonDriverService.fetchSeasonDriverById(id);
    if (seasonDriverDto == null) return null;
    final seasonDriver = _seasonDriverMapper.mapFromDto(seasonDriverDto);
    addEntity(seasonDriver);
    return seasonDriver;
  }
}
