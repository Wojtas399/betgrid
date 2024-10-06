import 'package:betgrid/data/firebase/model/race_bet_points_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/race_bet_points_creator.dart';

void main() {
  const RaceBetPointsCreator raceBetPointsCreator = RaceBetPointsCreator(
    dnfMultiplier: 3.2,
  );

  test(
    'fromJson, '
    'should map json model to class model',
    () {
      final Map<String, Object?> json = raceBetPointsCreator.createJson();
      final RaceBetPointsDto expectedModel = raceBetPointsCreator.createDto();

      final RaceBetPointsDto model = RaceBetPointsDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model',
    () {
      final RaceBetPointsDto model = raceBetPointsCreator.createDto();
      final Map<String, Object?> expectedJson =
          raceBetPointsCreator.createJson();

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
