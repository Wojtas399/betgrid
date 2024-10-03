import 'package:betgrid/data/firebase/model/grand_prix_bet_points_dto.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';

import 'quali_bet_points_creator.dart';
import 'race_bet_points_creator.dart';

class GrandPrixBetPointsCreator {
  final String id;
  final String playerId;
  final String grandPrixId;
  final double totalPoints;
  final QualiBetPointsCreator? qualiBetPointsCreator;
  final RaceBetPointsCreator? raceBetPointsCreator;

  const GrandPrixBetPointsCreator({
    this.id = '',
    this.playerId = '',
    this.grandPrixId = '',
    this.totalPoints = 0.0,
    this.qualiBetPointsCreator,
    this.raceBetPointsCreator,
  });

  GrandPrixBetPoints createEntity() => GrandPrixBetPoints(
        id: id,
        playerId: playerId,
        grandPrixId: grandPrixId,
        totalPoints: totalPoints,
        qualiBetPoints: qualiBetPointsCreator?.createEntity(),
        raceBetPoints: raceBetPointsCreator?.createEntity(),
      );

  GrandPrixBetPointsDto createDto() => GrandPrixBetPointsDto(
        id: id,
        playerId: playerId,
        grandPrixId: grandPrixId,
        totalPoints: totalPoints,
        qualiBetPointsDto: qualiBetPointsCreator?.createDto(),
        raceBetPointsDto: raceBetPointsCreator?.createDto(),
      );
}
