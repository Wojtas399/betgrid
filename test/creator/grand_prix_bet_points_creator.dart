import 'package:betgrid/model/grand_prix_bet_points.dart';

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
