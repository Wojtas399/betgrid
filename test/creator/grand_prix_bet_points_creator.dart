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

  GrandPrixBetPoints create() {
    return GrandPrixBetPoints(
      id: id,
      playerId: playerId,
      seasonGrandPrixId: seasonGrandPrixId,
      totalPoints: totalPoints,
      qualiBetPoints: qualiBetPointsCreator?.create(),
      raceBetPoints: raceBetPointsCreator?.create(),
    );
  }
}
