import 'package:betgrid/data/firebase/model/grand_prix_bet_points_dto.dart';
import 'package:flutter_test/flutter_test.dart';

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
      final Map<String, Object?> json = {
        'seasonGrandPrixId': seasonGrandPrixId,
        'totalPoints': totalPoints,
        'qualiBetPoints': qualiBetPointsCreator.createJson(),
        'raceBetPoints': raceBetPointsCreator.createJson(),
      };
      final GrandPrixBetPointsDto expectedModel = GrandPrixBetPointsDto(
        seasonGrandPrixId: seasonGrandPrixId,
        totalPoints: totalPoints,
        qualiBetPointsDto: qualiBetPointsCreator.createDto(),
        raceBetPointsDto: raceBetPointsCreator.createDto(),
      );

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
      final Map<String, Object?> json = {
        'seasonGrandPrixId': seasonGrandPrixId,
        'totalPoints': totalPoints,
        'qualiBetPoints': qualiBetPointsCreator.createJson(),
        'raceBetPoints': raceBetPointsCreator.createJson(),
      };
      final GrandPrixBetPointsDto expectedModel = GrandPrixBetPointsDto(
        id: id,
        playerId: playerId,
        seasonGrandPrixId: seasonGrandPrixId,
        totalPoints: totalPoints,
        qualiBetPointsDto: qualiBetPointsCreator.createDto(),
        raceBetPointsDto: raceBetPointsCreator.createDto(),
      );

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
      final GrandPrixBetPointsDto model = GrandPrixBetPointsDto(
        id: 'gpbp1',
        playerId: 'p1',
        seasonGrandPrixId: seasonGrandPrixId,
        totalPoints: totalPoints,
        qualiBetPointsDto: qualiBetPointsCreator.createDto(),
        raceBetPointsDto: raceBetPointsCreator.createDto(),
      );
      final Map<String, Object?> expectedJson = {
        'seasonGrandPrixId': seasonGrandPrixId,
        'totalPoints': totalPoints,
        'qualiBetPoints': qualiBetPointsCreator.createJson(),
        'raceBetPoints': raceBetPointsCreator.createJson(),
      };

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
