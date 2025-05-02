import 'package:betgrid_shared/firebase/model/season_driver_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_driver_service.dart';
import 'package:injectable/injectable.dart';

import '../../../model/season_driver.dart';
import '../../mapper/season_driver_mapper.dart';
import '../repository.dart';
import 'season_driver_repository.dart';

@LazySingleton(as: SeasonDriverRepository)
class SeasonDriverRepositoryImpl extends Repository<SeasonDriver>
    implements SeasonDriverRepository {
  final FirebaseSeasonDriverService _firebaseSeasonDriverService;
  final SeasonDriverMapper _seasonDriverMapper;

  SeasonDriverRepositoryImpl(
    this._firebaseSeasonDriverService,
    this._seasonDriverMapper,
  );

  @override
  Stream<List<SeasonDriver>> getAllFromSeason(int season) async* {
    await _fetchAllFromSeason(season);
    await for (final allSeasonDrivers in repositoryState$) {
      yield allSeasonDrivers
          .where((seasonDriver) => seasonDriver.season == season)
          .toList();
    }
  }

  @override
  Future<void> add({
    required int season,
    required String driverId,
    required int driverNumber,
    required String teamId,
  }) async {
    final SeasonDriverDto? addedSeasonDriverDto =
        await _firebaseSeasonDriverService.add(
          season: season,
          driverId: driverId,
          driverNumber: driverNumber,
          teamId: teamId,
        );
    if (addedSeasonDriverDto != null) {
      final SeasonDriver addedSeasonDriver = _seasonDriverMapper.mapFromDto(
        addedSeasonDriverDto,
      );
      addEntity(addedSeasonDriver);
    }
  }

  @override
  Future<void> delete({
    required int season,
    required String seasonDriverId,
  }) async {
    await _firebaseSeasonDriverService.delete(
      season: season,
      seasonDriverId: seasonDriverId,
    );
    deleteEntity(seasonDriverId);
  }

  Future<void> _fetchAllFromSeason(int season) async {
    final Iterable<SeasonDriverDto> dtos = await _firebaseSeasonDriverService
        .fetchAllFromSeason(season);
    if (dtos.isNotEmpty) {
      final Iterable<SeasonDriver> entities = dtos.map(
        _seasonDriverMapper.mapFromDto,
      );
      addOrUpdateEntities(entities);
    }
  }
}
