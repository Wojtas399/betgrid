import 'package:injectable/injectable.dart';

import '../../model/grand_prix_bet_points.dart';
import '../firebase/model/grand_prix_bet_points_dto.dart';
import 'quali_bet_points_mapper.dart';
import 'race_bet_points_mapper.dart';

@injectable
class GrandPrixBetPointsMapper {
  final QualiBetPointsMapper _qualiBetPointsMapper;
  final RaceBetPointsMapper _raceBetPointsMapper;

  const GrandPrixBetPointsMapper(
    this._qualiBetPointsMapper,
    this._raceBetPointsMapper,
  );

  GrandPrixBetPoints mapFromDto(
    GrandPrixBetPointsDto grandPrixBetPointsDto,
  ) =>
      GrandPrixBetPoints(
        id: grandPrixBetPointsDto.id,
        playerId: grandPrixBetPointsDto.playerId,
        grandPrixId: grandPrixBetPointsDto.grandPrixId,
        totalPoints: grandPrixBetPointsDto.totalPoints,
        qualiBetPoints: grandPrixBetPointsDto.qualiBetPointsDto != null
            ? _qualiBetPointsMapper.mapFromDto(
                grandPrixBetPointsDto.qualiBetPointsDto!,
              )
            : null,
        raceBetPoints: grandPrixBetPointsDto.raceBetPointsDto != null
            ? _raceBetPointsMapper.mapFromDto(
                grandPrixBetPointsDto.raceBetPointsDto!,
              )
            : null,
      );
}
