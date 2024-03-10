import '../../firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import '../../model/grand_prix_bet_points.dart';
import 'quali_bet_points_mapper.dart';
import 'race_bet_points_mapper.dart';

GrandPrixBetPoints mapGrandPrixBetPointsFromDto(
  GrandPrixBetPointsDto grandPrixBetPointsDto,
) =>
    GrandPrixBetPoints(
      id: grandPrixBetPointsDto.id,
      playerId: grandPrixBetPointsDto.playerId,
      grandPrixId: grandPrixBetPointsDto.grandPrixId,
      qualiBetPoints: grandPrixBetPointsDto.qualiBetPointsDto != null
          ? mapQualiBetPointsFromDto(grandPrixBetPointsDto.qualiBetPointsDto!)
          : null,
      raceBetPoints: grandPrixBetPointsDto.raceBetPointsDto != null
          ? mapRaceBetPointsFromDto(grandPrixBetPointsDto.raceBetPointsDto!)
          : null,
    );
