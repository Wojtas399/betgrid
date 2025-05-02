import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/driver_personal_data/driver_personal_data_repository.dart';
import '../data/repository/season_team/season_team_repository.dart';
import '../model/driver_details.dart';
import '../model/driver_personal_data.dart';
import '../model/season_driver.dart';
import '../model/season_team.dart';

@injectable
class GetDetailsForSeasonDriverUseCase {
  final DriverPersonalDataRepository _driverPersonalDataRepository;
  final SeasonTeamRepository _seasonTeamRepository;

  const GetDetailsForSeasonDriverUseCase(
    this._driverPersonalDataRepository,
    this._seasonTeamRepository,
  );

  Stream<DriverDetails?> call(SeasonDriver seasonDriver) {
    return Rx.combineLatest2(
      _driverPersonalDataRepository.getById(seasonDriver.driverId),
      _seasonTeamRepository.getById(
        id: seasonDriver.seasonTeamId,
        season: seasonDriver.season,
      ),
      (DriverPersonalData? personalData, SeasonTeam? seasonTeam) =>
          personalData != null && seasonTeam != null
              ? DriverDetails(
                seasonDriverId: seasonDriver.id,
                name: personalData.name,
                surname: personalData.surname,
                number: seasonDriver.driverNumber,
                teamName: seasonTeam.shortName,
                teamHexColor: seasonTeam.baseHexColor,
              )
              : null,
    );
  }
}
