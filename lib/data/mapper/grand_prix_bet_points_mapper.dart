import 'package:betgrid_shared/firebase/model/grand_prix_bet_points_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/season_grand_prix_bet_points.dart';
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

  SeasonGrandPrixBetPoints mapFromDto(
    GrandPrixBetPointsDto grandPrixBetPointsDto,
  ) =>
      SeasonGrandPrixBetPoints(
        id: grandPrixBetPointsDto.id,
        playerId: grandPrixBetPointsDto.playerId,
        season: grandPrixBetPointsDto.season,
        seasonGrandPrixId: grandPrixBetPointsDto.seasonGrandPrixId,
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
