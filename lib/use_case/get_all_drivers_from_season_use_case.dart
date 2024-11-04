import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/season_driver/season_driver_repository.dart';
import '../model/driver.dart';
import '../model/season_driver.dart';
import 'get_driver_based_on_season_driver_use_case.dart';

@injectable
class GetAllDriversFromSeasonUseCase {
  final SeasonDriverRepository _seasonDriverRepository;
  final GetDriverBasedOnSeasonDriverUseCase
      _getDriverBasedOnSeasonDriverUseCase;

  const GetAllDriversFromSeasonUseCase(
    this._seasonDriverRepository,
    this._getDriverBasedOnSeasonDriverUseCase,
  );

  Stream<List<Driver>> call(int season) {
    return _seasonDriverRepository
        .getAllSeasonDriversFromSeason(season)
        .switchMap(
          (List<SeasonDriver> allSeasonDrivers) => Rx.combineLatest(
            allSeasonDrivers.map(_getDriverBasedOnSeasonDriverUseCase.call),
            (List<Driver?> allDrivers) => allDrivers.whereNotNull().toList(),
          ),
        );
  }
}
