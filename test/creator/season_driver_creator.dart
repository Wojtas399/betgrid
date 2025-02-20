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

  SeasonDriver create() {
    return SeasonDriver(
      id: id,
      season: season,
      driverId: driverId,
      driverNumber: driverNumber,
      teamId: teamId,
    );
  }
}
