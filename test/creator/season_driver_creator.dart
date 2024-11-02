import 'package:betgrid/data/firebase/model/season_driver_dto.dart';

class SeasonDriverCreator {
  final String id;
  final int seasonNumber;
  final String driverId;
  final int driverNumber;
  final String teamId;

  const SeasonDriverCreator({
    this.id = '',
    this.seasonNumber = 0,
    this.driverId = '',
    this.driverNumber = 0,
    this.teamId = '',
  });

  SeasonDriverDto createDto() => SeasonDriverDto(
        id: id,
        seasonNumber: seasonNumber,
        driverId: driverId,
        driverNumber: driverNumber,
        teamId: teamId,
      );

  Map<String, Object?> createJson() => {
        'seasonNumber': seasonNumber,
        'driverId': driverId,
        'driverNumber': driverNumber,
        'teamId': teamId,
      };
}
