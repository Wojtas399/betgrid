import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/driver_personal_data/driver_personal_data_repository.dart';
import '../data/repository/team/team_repository.dart';
import '../model/driver.dart';
import '../model/driver_personal_data.dart';
import '../model/season_driver.dart';
import '../model/team.dart';

@injectable
class GetDriverBasedOnSeasonDriverUseCase {
  final DriverPersonalDataRepository _driverPersonalDataRepository;
  final TeamRepository _teamRepository;

  const GetDriverBasedOnSeasonDriverUseCase(
    this._driverPersonalDataRepository,
    this._teamRepository,
  );

  Stream<Driver?> call(SeasonDriver seasonDriver) {
    return Rx.combineLatest2(
      _driverPersonalDataRepository
          .getDriverPersonalDataById(seasonDriver.driverId),
      _teamRepository.getTeamById(seasonDriver.teamId),
      (DriverPersonalData? personalData, Team? team) =>
          personalData != null && team != null
              ? Driver(
                  seasonDriverId: seasonDriver.id,
                  name: personalData.name,
                  surname: personalData.surname,
                  number: seasonDriver.driverNumber,
                  teamName: team.name,
                  teamHexColor: team.hexColor,
                )
              : null,
    );
  }
}
