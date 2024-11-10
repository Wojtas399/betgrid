import 'package:betgrid/data/firebase/model/grand_prix_basic_info_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/grand_prix_basic_info_creator.dart';

void main() {
  const String id = 'gp1';
  const String name = 'Test Grand Prix';
  const String countryAlpha2Code = 'PL';

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      const creator = GrandPrixBasicInfoCreator(
        name: name,
        countryAlpha2Code: countryAlpha2Code,
      );
      final Map<String, Object?> json = creator.createJson();
      final GrandPrixBasicInfoDto expectedModel = creator.createDto();

      final GrandPrixBasicInfoDto model = GrandPrixBasicInfoDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model ignoring id',
    () {
      const creator = GrandPrixBasicInfoCreator(
        id: id,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
      );
      final GrandPrixBasicInfoDto model = creator.createDto();
      final Map<String, Object?> expectedJson = creator.createJson();

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id',
    () {
      const creator = GrandPrixBasicInfoCreator(
        id: id,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
      );
      final Map<String, Object?> json = creator.createJson();
      final GrandPrixBasicInfoDto expectedModel = creator.createDto();

      final GrandPrixBasicInfoDto model = GrandPrixBasicInfoDto.fromFirebase(
        id: id,
        json: json,
      );

      expect(model, expectedModel);
    },
  );
}
