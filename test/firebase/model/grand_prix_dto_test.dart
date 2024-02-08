import 'package:betgrid/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String name = 'Test Grand Prix';
  final DateTime startDate = DateTime(2024);
  final DateTime endDate = DateTime(2024, 1, 3);
  print(startDate.toIso8601String());

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      final Map<String, Object?> json = {
        'name': name,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };
      final GrandPrixDto expectedModel = GrandPrixDto(
        id: '',
        name: name,
        startDate: startDate,
        endDate: endDate,
      );

      final GrandPrixDto model = GrandPrixDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model ignoring id',
    () {
      final GrandPrixDto model = GrandPrixDto(
        id: 'gp1',
        name: name,
        startDate: startDate,
        endDate: endDate,
      );
      final Map<String, Object?> expectedJson = {
        'name': name,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'fromIdAndJson, '
    'should map json model to class model with given id',
    () {
      const String id = 'gp1';
      final Map<String, Object?> json = {
        'name': name,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };
      final GrandPrixDto expectedModel = GrandPrixDto(
        id: id,
        name: name,
        startDate: startDate,
        endDate: endDate,
      );

      final GrandPrixDto model = GrandPrixDto.fromIdAndJson(id, json);

      expect(model, expectedModel);
    },
  );
}
