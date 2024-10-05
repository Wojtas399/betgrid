import 'package:betgrid/data/firebase/model/grand_prix_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const int season = 2024;
  const int roundNumber = 4;
  const String name = 'Test Grand Prix';
  const String countryAlpha2Code = 'PL';
  final DateTime startDate = DateTime(2024);
  final DateTime endDate = DateTime(2024, 1, 3);

  Map<String, Object?> createJson() => {
        'season': season,
        'roundNumber': roundNumber,
        'name': name,
        'countryAlpha2Code': countryAlpha2Code,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

  GrandPrixDto createDto() => GrandPrixDto(
        season: season,
        roundNumber: roundNumber,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
        startDate: startDate,
        endDate: endDate,
      );

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      final Map<String, Object?> json = createJson();
      final GrandPrixDto expectedModel = createDto();

      final GrandPrixDto model = GrandPrixDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model ignoring id',
    () {
      final GrandPrixDto model = createDto().copyWith(id: 'gp1');
      final Map<String, Object?> expectedJson = createJson();

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id',
    () {
      const String id = 'gp1';
      final Map<String, Object?> json = createJson();
      final GrandPrixDto expectedModel = createDto().copyWith(id: id);

      final GrandPrixDto model = GrandPrixDto.fromFirebase(
        id: id,
        json: json,
      );

      expect(model, expectedModel);
    },
  );
}
