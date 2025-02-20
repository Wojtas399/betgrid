import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/driver_personal_data/driver_personal_data_repository.dart';
import '../data/repository/team_basic_info/team_basic_info_repository.dart';
import '../model/driver_details.dart';
import '../model/driver_personal_data.dart';
import '../model/season_driver.dart';
import '../model/team_basic_info.dart';

@injectable
class GetDetailsForSeasonDriverUseCase {
  final DriverPersonalDataRepository _driverPersonalDataRepository;
  final TeamBasicInfoRepository _teamBasicInfoRepository;

  const GetDetailsForSeasonDriverUseCase(
    this._driverPersonalDataRepository,
    this._teamBasicInfoRepository,
  );

  Stream<DriverDetails?> call(SeasonDriver seasonDriver) {
    return Rx.combineLatest2(
      _driverPersonalDataRepository.getDriverPersonalDataById(
        seasonDriver.driverId,
      ),
      _teamBasicInfoRepository.getById(seasonDriver.teamId),
      (DriverPersonalData? personalData, TeamBasicInfo? teamBasicInfo) =>
          personalData != null && teamBasicInfo != null
              ? DriverDetails(
                seasonDriverId: seasonDriver.id,
                name: personalData.name,
                surname: personalData.surname,
                number: seasonDriver.driverNumber,
                teamName: teamBasicInfo.name,
                teamHexColor: teamBasicInfo.hexColor,
              )
              : null,
    );
  }
}
