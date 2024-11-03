import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/driver/driver_repository.dart';
import '../data/repository/season_driver/season_driver_repository.dart';
import '../data/repository/team/team_repository.dart';
import '../model/driver.dart';
import '../model/driver_details.dart';
import '../model/season_driver.dart';
import '../model/team.dart' as team_model;

@injectable
class GetDriverDetailsUseCase {
  final DriverRepository _driverRepository;
  final SeasonDriverRepository _seasonDriverRepository;
  final TeamRepository _teamRepository;

  const GetDriverDetailsUseCase(
    this._driverRepository,
    this._seasonDriverRepository,
    this._teamRepository,
  );

  Stream<DriverDetails?> call({
    required String driverId,
    required int season,
  }) {
    return Rx.combineLatest2(
      _driverRepository.getDriverById(driverId: driverId),
      _seasonDriverRepository.getSeasonDriverByDriverIdAndSeason(
        driverId: driverId,
        season: season,
      ),
      (Driver? driver, SeasonDriver? seasonDriver) =>
          driver != null && seasonDriver != null
              ? (driver: driver, seasonDriver: seasonDriver)
              : null,
    ).switchMap(
      (_ListenedData? data) => data != null
          ? _teamRepository.getTeamById(data.seasonDriver.teamId).map(
                (team_model.Team? team) => team != null
                    ? DriverDetails(
                        driver: data.driver,
                        seasonDriver: data.seasonDriver,
                        team: team,
                      )
                    : null,
              )
          : Stream.value(null),
    );
  }
}

typedef _ListenedData = ({Driver driver, SeasonDriver seasonDriver});
