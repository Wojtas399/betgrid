import 'package:betgrid/data/firebase/model/team_basic_info_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/team_basic_info_creator.dart';

void main() {
  const String name = 'Mercedes';
  const String hexColor = '#FFFFFF';

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      const teamBasicInfoCreator = TeamBasicInfoCreator(
        name: name,
        hexColor: hexColor,
      );
      final Map<String, Object?> json = teamBasicInfoCreator.createJson();
      final TeamBasicInfoDto expectedModel = teamBasicInfoCreator.createDto();

      final TeamBasicInfoDto model = TeamBasicInfoDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id',
    () {
      const String id = 'd1';
      const teamBasicInfoCreator = TeamBasicInfoCreator(
        id: id,
        name: name,
        hexColor: hexColor,
      );
      final Map<String, Object?> json = teamBasicInfoCreator.createJson();
      final TeamBasicInfoDto expectedModel = teamBasicInfoCreator.createDto();

      final TeamBasicInfoDto model = TeamBasicInfoDto.fromFirebase(
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
      const teamBasicInfoCreator = TeamBasicInfoCreator(
        id: 'd1',
        name: name,
        hexColor: hexColor,
      );
      final TeamBasicInfoDto model = teamBasicInfoCreator.createDto();
      final Map<String, Object?> expectedJson =
          teamBasicInfoCreator.createJson();

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
