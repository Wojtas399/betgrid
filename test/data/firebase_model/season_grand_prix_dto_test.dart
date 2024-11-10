import 'package:betgrid/data/firebase/model/season_grand_prix_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/season_grand_prix_creator.dart';

void main() {
  const String id = 'gp1';
  const int season = 2024;
  const String grandPrixId = 'gp1';
  const int roundNumber = 1;
  final DateTime startDate = DateTime(2024);
  final DateTime endDate = DateTime(2024, 1, 2);

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      final creator = SeasonGrandPrixCreator(
        season: season,
        grandPrixId: grandPrixId,
        roundNumber: roundNumber,
        startDate: startDate,
        endDate: endDate,
      );
      final Map<String, Object?> json = creator.createJson();
      final SeasonGrandPrixDto expectedModel = creator.createDto();

      final SeasonGrandPrixDto model = SeasonGrandPrixDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model ignoring id',
    () {
      final creator = SeasonGrandPrixCreator(
        id: id,
        season: season,
        grandPrixId: grandPrixId,
        roundNumber: roundNumber,
        startDate: startDate,
        endDate: endDate,
      );
      final SeasonGrandPrixDto model = creator.createDto();
      final Map<String, Object?> expectedJson = creator.createJson();

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id',
    () {
      final creator = SeasonGrandPrixCreator(
        id: id,
        season: season,
        grandPrixId: grandPrixId,
        roundNumber: roundNumber,
        startDate: startDate,
        endDate: endDate,
      );
      final Map<String, Object?> json = creator.createJson();
      final SeasonGrandPrixDto expectedModel = creator.createDto();

      final SeasonGrandPrixDto model = SeasonGrandPrixDto.fromFirebase(
        id: id,
        json: json,
      );

      expect(model, expectedModel);
    },
  );
}
