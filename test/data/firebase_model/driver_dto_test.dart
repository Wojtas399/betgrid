import 'package:betgrid/data/firebase/model/driver_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String name = 'Robert';
  const String surname = 'Kubica';
  const int number = 1;
  const TeamDto team = TeamDto.ferrari;

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      final Map<String, Object?> json = {
        'name': name,
        'surname': surname,
        'number': number,
        'team': 'ferrari',
      };
      const DriverDto expectedModel = DriverDto(
        name: name,
        surname: surname,
        number: number,
        team: team,
      );

      final DriverDto model = DriverDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id',
    () {
      const String id = 'd1';
      final Map<String, Object?> json = {
        'name': name,
        'surname': surname,
        'number': number,
        'team': 'ferrari',
      };
      const DriverDto expectedModel = DriverDto(
        id: id,
        name: name,
        surname: surname,
        number: number,
        team: team,
      );

      final DriverDto model = DriverDto.fromFirebase(id: id, json: json);

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
        number: number,
        team: team,
      );
      final Map<String, Object?> expectedJson = {
        'name': name,
        'surname': surname,
        'number': number,
        'team': 'ferrari',
      };

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
