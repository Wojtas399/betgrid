import 'package:betgrid/data/mapper/season_driver_mapper.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/season_driver_creator.dart';

void main() {
  final mapper = SeasonDriverMapper();

  test(
    'mapFromDto, '
    'should map SeasonDriverDto model to SeasonDriver model',
    () {
      const String id = 'sd1';
      const int seasonNumber = 2024;
      const String driverId = 'd1';
      const int driverNumber = 11;
      const String teamId = 't1';
      const seasonDriverCreator = SeasonDriverCreator(
        id: id,
        seasonNumber: seasonNumber,
        driverId: driverId,
        driverNumber: driverNumber,
        teamId: teamId,
      );
      final seasonDriverDto = seasonDriverCreator.createDto();
      final expectedSeasonDriver = seasonDriverCreator.createEntity();

      final SeasonDriver seasonDriver = mapper.mapFromDto(seasonDriverDto);

      expect(seasonDriver, expectedSeasonDriver);
    },
  );
}
