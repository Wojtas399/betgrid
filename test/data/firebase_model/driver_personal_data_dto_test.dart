import 'package:betgrid/data/firebase/model/driver_personal_data_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/driver_personal_data_creator.dart';

void main() {
  const String name = 'Robert';
  const String surname = 'Kubica';

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      const creator = DriverPersonalDataCreator(
        name: name,
        surname: surname,
      );
      final Map<String, Object?> json = creator.createJson();
      final DriverPersonalDataDto expectedModel = creator.createDto();

      final DriverPersonalDataDto model = DriverPersonalDataDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id',
    () {
      const String id = 'd1';
      const creator = DriverPersonalDataCreator(
        id: id,
        name: name,
        surname: surname,
      );
      final Map<String, Object?> json = creator.createJson();
      final DriverPersonalDataDto expectedModel = creator.createDto();

      final DriverPersonalDataDto model = DriverPersonalDataDto.fromFirebase(
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
      const creator = DriverPersonalDataCreator(
        id: 'd1',
        name: name,
        surname: surname,
      );
      final DriverPersonalDataDto model = creator.createDto();
      final Map<String, Object?> expectedJson = creator.createJson();

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
