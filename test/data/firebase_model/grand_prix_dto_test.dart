import 'package:betgrid/data/firebase/model/grand_prix_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const int roundNumber = 4;
  const String name = 'Test Grand Prix';
  const String countryAlpha2Code = 'PL';
  final DateTime startDate = DateTime(2024);
  final DateTime endDate = DateTime(2024, 1, 3);

  test(
    'fromJson, '
    'should map json model to class model ignoring id and season',
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
    'should map class model to json model ignoring id and season',
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
    'fromFirebase, '
    'should map json model to class model with given id and season',
    () {
      const String id = 'gp1';
      const int season = 2024;
      final Map<String, Object?> json = {
        'roundNumber': roundNumber,
        'name': name,
        'countryAlpha2Code': countryAlpha2Code,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };
      final GrandPrixDto expectedModel = GrandPrixDto(
        id: id,
        season: season,
        roundNumber: roundNumber,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
        startDate: startDate,
        endDate: endDate,
      );

      final GrandPrixDto model = GrandPrixDto.fromFirebase(
        id: id,
        season: season,
        json: json,
      );

      expect(model, expectedModel);
    },
  );
}
