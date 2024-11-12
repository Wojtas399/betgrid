import 'package:betgrid/data/firebase/model/grand_prix_bet_points_dto.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';

import 'quali_bet_points_creator.dart';
import 'race_bet_points_creator.dart';

class GrandPrixBetPointsCreator {
  final String id;
  final String playerId;
  final String seasonGrandPrixId;
  final double totalPoints;
  final QualiBetPointsCreator? qualiBetPointsCreator;
  final RaceBetPointsCreator? raceBetPointsCreator;

  const GrandPrixBetPointsCreator({
    this.id = '',
    this.playerId = '',
    this.seasonGrandPrixId = '',
    this.totalPoints = 0.0,
    this.qualiBetPointsCreator,
    this.raceBetPointsCreator,
  });

  GrandPrixBetPoints createEntity() {
    return GrandPrixBetPoints(
      id: id,
      playerId: playerId,
      seasonGrandPrixId: seasonGrandPrixId,
      totalPoints: totalPoints,
      qualiBetPoints: qualiBetPointsCreator?.createEntity(),
      raceBetPoints: raceBetPointsCreator?.createEntity(),
    );
  }

  GrandPrixBetPointsDto createDto() {
    return GrandPrixBetPointsDto(
      id: id,
      playerId: playerId,
      seasonGrandPrixId: seasonGrandPrixId,
      totalPoints: totalPoints,
      qualiBetPointsDto: qualiBetPointsCreator?.createDto(),
      raceBetPointsDto: raceBetPointsCreator?.createDto(),
    );
  }

  Map<String, Object?> createJson() {
    return {
      'seasonGrandPrixId': seasonGrandPrixId,
      'totalPoints': totalPoints,
      'qualiBetPoints': qualiBetPointsCreator?.createJson(),
      'raceBetPoints': raceBetPointsCreator?.createJson(),
    };
  }
}
