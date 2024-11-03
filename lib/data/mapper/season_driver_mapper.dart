import 'package:injectable/injectable.dart';

import '../../model/season_driver.dart';
import '../firebase/model/season_driver_dto.dart';

@injectable
class SeasonDriverMapper {
  SeasonDriver mapFromDto(SeasonDriverDto seasonDriverDto) {
    return SeasonDriver(
      id: seasonDriverDto.id,
      seasonNumber: seasonDriverDto.seasonNumber,
      driverId: seasonDriverDto.driverId,
      driverNumber: seasonDriverDto.driverNumber,
      teamId: seasonDriverDto.teamId,
    );
  }
}
