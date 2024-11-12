import 'package:betgrid/data/firebase/model/grand_prix_bet_points_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/grand_prix_bet_points_creator.dart';
import '../../creator/quali_bet_points_creator.dart';
import '../../creator/race_bet_points_creator.dart';

void main() {
  const String seasonGrandPrixId = 'gp1';
  const double totalPoints = 10.2;
  const QualiBetPointsCreator qualiBetPointsCreator = QualiBetPointsCreator();
  const RaceBetPointsCreator raceBetPointsCreator = RaceBetPointsCreator();

  test(
    'fromJson, '
    'should map json model to class model ignoring id and playerId',
    () {
      const creator = GrandPrixBetPointsCreator(
        seasonGrandPrixId: seasonGrandPrixId,
        totalPoints: totalPoints,
        qualiBetPointsCreator: qualiBetPointsCreator,
        raceBetPointsCreator: raceBetPointsCreator,
      );
      final Map<String, Object?> json = creator.createJson();
      final GrandPrixBetPointsDto expectedModel = creator.createDto();

      final GrandPrixBetPointsDto model = GrandPrixBetPointsDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id and playerId',
    () {
      const String id = 'gpbp1';
      const String playerId = 'p1';
      const creator = GrandPrixBetPointsCreator(
        id: id,
        playerId: playerId,
        seasonGrandPrixId: seasonGrandPrixId,
        totalPoints: totalPoints,
        qualiBetPointsCreator: qualiBetPointsCreator,
        raceBetPointsCreator: raceBetPointsCreator,
      );
      final Map<String, Object?> json = creator.createJson();
      final GrandPrixBetPointsDto expectedModel = creator.createDto();

      final GrandPrixBetPointsDto model = GrandPrixBetPointsDto.fromFirebase(
        id: id,
        playerId: playerId,
        json: json,
      );

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model ignoring id and playerId',
    () {
      const creator = GrandPrixBetPointsCreator(
        id: 'gpb1',
        playerId: 'p1',
        seasonGrandPrixId: seasonGrandPrixId,
        totalPoints: totalPoints,
        qualiBetPointsCreator: qualiBetPointsCreator,
        raceBetPointsCreator: raceBetPointsCreator,
      );
      final GrandPrixBetPointsDto model = creator.createDto();
      final Map<String, Object?> expectedJson = creator.createJson();

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
