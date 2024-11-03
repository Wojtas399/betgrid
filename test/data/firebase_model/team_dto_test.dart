import 'package:betgrid/data/firebase/model/team_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/team_creator.dart';

void main() {
  const String name = 'Mercedes';
  const String hexColor = '#FFFFFF';

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      const teamCreator = TeamCreator(
        name: name,
        hexColor: hexColor,
      );
      final Map<String, Object?> json = teamCreator.createJson();
      final TeamDto expectedModel = teamCreator.createDto();

      final TeamDto model = TeamDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id',
    () {
      const String id = 'd1';
      const teamCreator = TeamCreator(
        id: id,
        name: name,
        hexColor: hexColor,
      );
      final Map<String, Object?> json = teamCreator.createJson();
      final TeamDto expectedModel = teamCreator.createDto();

      final TeamDto model = TeamDto.fromFirebase(id: id, json: json);

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model ignoring id',
    () {
      const teamCreator = TeamCreator(
        id: 'd1',
        name: name,
        hexColor: hexColor,
      );
      final TeamDto model = teamCreator.createDto();
      final Map<String, Object?> expectedJson = teamCreator.createJson();

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
