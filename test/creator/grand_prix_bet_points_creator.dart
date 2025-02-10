import 'package:betgrid/model/season_grand_prix_bet_points.dart';

import 'quali_bet_points_creator.dart';
import 'race_bet_points_creator.dart';

class SeasonGrandPrixBetPointsCreator {
  final String id;
  final String playerId;
  final int season;
  final String seasonGrandPrixId;
  final double totalPoints;
  final QualiBetPointsCreator? qualiBetPointsCreator;
  final RaceBetPointsCreator? raceBetPointsCreator;

  const SeasonGrandPrixBetPointsCreator({
    this.id = '',
    this.playerId = '',
    this.season = 0,
    this.seasonGrandPrixId = '',
    this.totalPoints = 0.0,
    this.qualiBetPointsCreator,
    this.raceBetPointsCreator,
  });

  SeasonGrandPrixBetPoints create() {
    return SeasonGrandPrixBetPoints(
      id: id,
      playerId: playerId,
      season: season,
      seasonGrandPrixId: seasonGrandPrixId,
      totalPoints: totalPoints,
      qualiBetPoints: qualiBetPointsCreator?.create(),
      raceBetPoints: raceBetPointsCreator?.create(),
    );
  }
}
