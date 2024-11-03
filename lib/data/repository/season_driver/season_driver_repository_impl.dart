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
  final _getAllDriversMutex = Mutex();

  SeasonDriverRepositoryImpl(
    this._firebaseSeasonDriverService,
    this._seasonDriverMapper,
  );

  @override
  Stream<List<SeasonDriver>> getAllDriversFromSeason(int season) async* {
    await _getAllDriversMutex.acquire();
    await _fetchAllSeasonDriversFromSeason(season);
    await for (final allSeasonDrivers in repositoryState$) {
      yield allSeasonDrivers
          .where((seasonDriver) => seasonDriver.season == season)
          .toList();
    }
  }

  Future<void> _fetchAllSeasonDriversFromSeason(int season) async {
    final seasonDriverDtos =
        await _firebaseSeasonDriverService.fetchAllDriversFromSeason(season);
    if (seasonDriverDtos.isNotEmpty) {
      final seasonDrivers =
          seasonDriverDtos.map(_seasonDriverMapper.mapFromDto);
      addOrUpdateEntities(seasonDrivers);
    }
  }
}
