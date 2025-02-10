import 'package:betgrid_shared/firebase/service/firebase_season_driver_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/season_driver.dart';
import '../../mapper/season_driver_mapper.dart';
import '../repository.dart';
import 'season_driver_repository.dart';

@LazySingleton(as: SeasonDriverRepository)
class SeasonDriverRepositoryImpl extends Repository<SeasonDriver>
    implements SeasonDriverRepository {
  final FirebaseSeasonDriverService _fireSeasonDriverService;
  final SeasonDriverMapper _seasonDriverMapper;
  final _getAllFromSeasonMutex = Mutex();
  final _getByIdMutex = Mutex();

  SeasonDriverRepositoryImpl(
    this._fireSeasonDriverService,
    this._seasonDriverMapper,
  );

  @override
  Stream<List<SeasonDriver>> getAllFromSeason(int season) async* {
    bool didRelease = false;
    await _getAllFromSeasonMutex.acquire();
    await _fetchFromSeason(season);
    await for (final allSeasonDrivers in repositoryState$) {
      if (_getAllFromSeasonMutex.isLocked && !didRelease) {
        _getAllFromSeasonMutex.release();
        didRelease = true;
      }
      yield allSeasonDrivers
          .where((seasonDriver) => seasonDriver.season == season)
          .toList();
    }
  }

  @override
  Stream<SeasonDriver?> getById({
    required int season,
    required String seasonDriverId,
  }) async* {
    bool didRelease = false;
    await _getByIdMutex.acquire();
    await for (final allSeasonDrivers in repositoryState$) {
      SeasonDriver? matchingSeasonDriver = allSeasonDrivers.firstWhereOrNull(
        (seasonDriver) => seasonDriver.id == seasonDriverId,
      );
      matchingSeasonDriver ??= await _fetchById(season, seasonDriverId);
      if (_getByIdMutex.isLocked && !didRelease) {
        _getByIdMutex.release();
        didRelease = true;
      }
      yield matchingSeasonDriver;
    }
  }

  Future<void> _fetchFromSeason(int season) async {
    final seasonDriverDtos =
        await _fireSeasonDriverService.fetchAllFromSeason(season);
    if (seasonDriverDtos.isNotEmpty) {
      final seasonDrivers =
          seasonDriverDtos.map(_seasonDriverMapper.mapFromDto);
      addOrUpdateEntities(seasonDrivers);
    }
  }

  Future<SeasonDriver?> _fetchById(int season, String seasonDriverId) async {
    final seasonDriverDto = await _fireSeasonDriverService.fetchById(
      season: season,
      seasonDriverId: seasonDriverId,
    );
    if (seasonDriverDto == null) return null;
    final seasonDriver = _seasonDriverMapper.mapFromDto(seasonDriverDto);
    addEntity(seasonDriver);
    return seasonDriver;
  }
}
