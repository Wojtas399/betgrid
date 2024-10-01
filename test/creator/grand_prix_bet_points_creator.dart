import 'package:betgrid/model/grand_prix_bet_points.dart';

import 'quali_bet_points_creator.dart';

class GrandPrixBetPointsCreator {
  final String id;
  final String playerId;
  final String grandPrixId;
  final double totalPoints;
  final QualiBetPointsCreator? qualiBetPointsCreator;
  final RaceBetPoints? raceBetPoints;

  const GrandPrixBetPointsCreator({
    this.id = '',
    this.playerId = '',
    this.grandPrixId = '',
    this.totalPoints = 0.0,
    this.qualiBetPointsCreator,
    this.raceBetPoints,
  });
}

GrandPrixBetPoints createGrandPrixBetPoints({
  String id = '',
  String playerId = '',
  String grandPrixId = '',
  double totalPoints = 0.0,
  QualiBetPoints? qualiBetPoints,
  RaceBetPoints? raceBetPoints,
}) =>
    GrandPrixBetPoints(
      id: id,
      playerId: playerId,
      grandPrixId: grandPrixId,
      totalPoints: totalPoints,
      qualiBetPoints: qualiBetPoints,
      raceBetPoints: raceBetPoints,
    );
