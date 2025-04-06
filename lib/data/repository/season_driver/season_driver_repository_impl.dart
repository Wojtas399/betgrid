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
  final _mutex = Mutex();

  SeasonDriverRepositoryImpl(
    this._fireSeasonDriverService,
    this._seasonDriverMapper,
  );

  @override
  Stream<List<SeasonDriver>> getAllFromSeason(int season) async* {
    bool didRelease = false;
    await _mutex.acquire();
    await _fetchFromSeason(season);
    await for (final allSeasonDrivers in repositoryState$) {
      if (_mutex.isLocked && !didRelease) {
        _mutex.release();
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
    await _mutex.acquire();
    await for (final allSeasonDrivers in repositoryState$) {
      SeasonDriver? matchingSeasonDriver = allSeasonDrivers.firstWhereOrNull(
        (seasonDriver) => seasonDriver.id == seasonDriverId,
      );
      matchingSeasonDriver ??= await _fetchById(season, seasonDriverId);
      if (_mutex.isLocked && !didRelease) {
        _mutex.release();
        didRelease = true;
      }
      yield matchingSeasonDriver;
    }
  }

  @override
  Stream<List<SeasonDriver>> getBySeasonTeamId({
    required int season,
    required String seasonTeamId,
  }) async* {
    await _fetchBySeasonTeamId(season, seasonTeamId);

    await for (final entities in repositoryState$) {
      yield entities
          .where(
            (seasonDriver) =>
                seasonDriver.season == season &&
                seasonDriver.seasonTeamId == seasonTeamId,
          )
          .toList();
    }
  }

  Future<void> _fetchFromSeason(int season) async {
    final seasonDriverDtos = await _fireSeasonDriverService.fetchAllFromSeason(
      season,
    );
    if (seasonDriverDtos.isNotEmpty) {
      final seasonDrivers = seasonDriverDtos.map(
        _seasonDriverMapper.mapFromDto,
      );
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

  Future<void> _fetchBySeasonTeamId(int season, String seasonTeamId) async {
    final seasonDriverDtos = await _fireSeasonDriverService.fetchAllFromSeason(
      season,
    );
    if (seasonDriverDtos.isNotEmpty) {
      final seasonDrivers = seasonDriverDtos.map(
        _seasonDriverMapper.mapFromDto,
      );
      addOrUpdateEntities(seasonDrivers);
    }
  }
}
