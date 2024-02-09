import 'package:betgrid/firebase/model/driver_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String name = 'Robert';
  const String surname = 'Kubica';
  const TeamDto team = TeamDto.ferrari;

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      final Map<String, Object?> json = {
        'name': name,
        'surname': surname,
        'team': 'ferrari',
      };
      const DriverDto expectedModel = DriverDto(
        name: name,
        surname: surname,
        team: team,
      );

      final DriverDto model = DriverDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'fromIdAndJson, '
    'should map json model to class model with given id',
    () {
      const String id = 'd1';
      final Map<String, Object?> json = {
        'name': name,
        'surname': surname,
        'team': 'ferrari',
      };
      const DriverDto expectedModel = DriverDto(
        id: id,
        name: name,
        surname: surname,
        team: team,
      );

      final DriverDto model = DriverDto.fromIdAndJson(id, json);

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model ignoring id',
    () {
      const DriverDto model = DriverDto(
        id: 'd1',
        name: name,
        surname: surname,
        team: team,
      );
      final Map<String, Object?> expectedJson = {
        'name': name,
        'surname': surname,
        'team': 'ferrari',
      };

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
