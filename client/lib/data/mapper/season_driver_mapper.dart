import 'package:betgrid_shared/firebase/model/season_driver_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/season_driver.dart';

@injectable
class SeasonDriverMapper {
  SeasonDriver mapFromDto(SeasonDriverDto dto) {
    return SeasonDriver(
      id: dto.id,
      season: dto.season,
      driverId: dto.driverId,
      driverNumber: dto.driverNumber,
      seasonTeamId: dto.seasonTeamId,
    );
  }
}
