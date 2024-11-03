import 'package:betgrid/data/firebase/model/season_driver_dto.dart';
import 'package:betgrid/model/season_driver.dart';

class SeasonDriverCreator {
  final String id;
  final int season;
  final String driverId;
  final int driverNumber;
  final String teamId;

  const SeasonDriverCreator({
    this.id = '',
    this.season = 0,
    this.driverId = '',
    this.driverNumber = 0,
    this.teamId = '',
  });

  SeasonDriver createEntity() {
    return SeasonDriver(
      id: id,
      season: season,
      driverId: driverId,
      driverNumber: driverNumber,
      teamId: teamId,
    );
  }

  SeasonDriverDto createDto() {
    return SeasonDriverDto(
      id: id,
      season: season,
      driverId: driverId,
      driverNumber: driverNumber,
      teamId: teamId,
    );
  }

  Map<String, Object?> createJson() {
    return {
      'season': season,
      'driverId': driverId,
      'driverNumber': driverNumber,
      'teamId': teamId,
    };
  }
}
