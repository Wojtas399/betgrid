import 'package:betgrid/data/firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';

GrandPrixBetPointsDto createGrandPrixBetPointsDto({
  String id = '',
  String playerId = '',
  String grandPrixId = '',
  double totalPoints = 0.0,
  QualiBetPointsDto? qualiBetPointsDto,
  RaceBetPointsDto? raceBetPointsDto,
}) =>
    GrandPrixBetPointsDto(
      id: id,
      playerId: playerId,
      grandPrixId: grandPrixId,
      totalPoints: totalPoints,
      qualiBetPointsDto: qualiBetPointsDto,
      raceBetPointsDto: raceBetPointsDto,
    );
