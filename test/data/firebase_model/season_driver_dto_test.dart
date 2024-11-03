import 'package:betgrid/data/firebase/model/season_driver_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/season_driver_creator.dart';

void main() {
  const int season = 2024;
  const String driverId = 'd1';
  const int driverNumber = 1;
  const String teamId = 't1';

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      const seasonDriverCreator = SeasonDriverCreator(
        season: season,
        driverId: driverId,
        driverNumber: driverNumber,
        teamId: teamId,
      );
      final Map<String, Object?> json = seasonDriverCreator.createJson();
      final SeasonDriverDto expectedModel = seasonDriverCreator.createDto();

      final SeasonDriverDto model = SeasonDriverDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id',
    () {
      const String id = 'd1';
      const seasonDriverCreator = SeasonDriverCreator(
        id: id,
        season: season,
        driverId: driverId,
        driverNumber: driverNumber,
        teamId: teamId,
      );
      final Map<String, Object?> json = seasonDriverCreator.createJson();
      final SeasonDriverDto expectedModel = seasonDriverCreator.createDto();

      final SeasonDriverDto model = SeasonDriverDto.fromFirebase(
        id: id,
        json: json,
      );

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model ignoring id',
    () {
      const seasonDriverCreator = SeasonDriverCreator(
        id: 'd1',
        season: season,
        driverId: driverId,
        driverNumber: driverNumber,
        teamId: teamId,
      );
      final SeasonDriverDto model = seasonDriverCreator.createDto();
      final Map<String, Object?> expectedJson =
          seasonDriverCreator.createJson();

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
