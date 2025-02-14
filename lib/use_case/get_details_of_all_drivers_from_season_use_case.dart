import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/season_driver/season_driver_repository.dart';
import '../model/driver_details.dart';
import '../model/season_driver.dart';
import 'get_details_for_season_driver_use_case.dart';

@injectable
class GetDetailsOfAllDriversFromSeasonUseCase {
  final SeasonDriverRepository _seasonDriverRepository;
  final GetDetailsForSeasonDriverUseCase _getDetailsForSeasonDriverUseCase;

  const GetDetailsOfAllDriversFromSeasonUseCase(
    this._seasonDriverRepository,
    this._getDetailsForSeasonDriverUseCase,
  );

  Stream<List<DriverDetails>> call(int season) {
    return _seasonDriverRepository
        .getAllFromSeason(season)
        .switchMap(
          (List<SeasonDriver> allDriversFromSeason) => Rx.combineLatest(
            allDriversFromSeason.map(_getDetailsForSeasonDriverUseCase.call),
            (List<DriverDetails?> detailsOfDrivers) =>
                detailsOfDrivers.whereType<DriverDetails>().toList(),
          ),
        );
  }
}
