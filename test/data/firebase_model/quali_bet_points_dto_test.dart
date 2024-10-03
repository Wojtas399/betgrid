import 'package:betgrid/data/firebase/model/quali_bet_points_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/quali_bet_points_creator.dart';

void main() {
  final QualiBetPointsCreator qualiBetPointsCreator = QualiBetPointsCreator(
    q1Multiplier: 1.2,
    q3Multiplier: 2.5,
    multiplier: 3.8,
  );

  test(
    'fromJson, '
    'should map json model to class model',
    () {
      final Map<String, Object?> json = qualiBetPointsCreator.createJson();
      final QualiBetPointsDto expectedModel = qualiBetPointsCreator.createDto();

      final QualiBetPointsDto model = QualiBetPointsDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model',
    () {
      final QualiBetPointsDto model = qualiBetPointsCreator.createDto();
      final Map<String, Object?> expectedJson =
          qualiBetPointsCreator.createJson();

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
