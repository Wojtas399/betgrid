import 'package:betgrid/data/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const int roundNumber = 4;
  const String name = 'Test Grand Prix';
  const String countryAlpha2Code = 'PL';
  final DateTime startDate = DateTime(2024);
  final DateTime endDate = DateTime(2024, 1, 3);

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      final Map<String, Object?> json = {
        'roundNumber': roundNumber,
        'name': name,
        'countryAlpha2Code': countryAlpha2Code,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };
      final GrandPrixDto expectedModel = GrandPrixDto(
        id: '',
        roundNumber: roundNumber,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
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
        roundNumber: roundNumber,
        id: 'gp1',
        name: name,
        countryAlpha2Code: countryAlpha2Code,
        startDate: startDate,
        endDate: endDate,
      );
      final Map<String, Object?> expectedJson = {
        'roundNumber': roundNumber,
        'name': name,
        'countryAlpha2Code': countryAlpha2Code,
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
        'roundNumber': roundNumber,
        'name': name,
        'countryAlpha2Code': countryAlpha2Code,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };
      final GrandPrixDto expectedModel = GrandPrixDto(
        roundNumber: roundNumber,
        id: id,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
        startDate: startDate,
        endDate: endDate,
      );

      final GrandPrixDto model = GrandPrixDto.fromIdAndJson(id, json);

      expect(model, expectedModel);
    },
  );
}
