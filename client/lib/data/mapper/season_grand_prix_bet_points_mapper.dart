import 'package:betgrid_shared/firebase/model/season_grand_prix_bet_points_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/season_grand_prix_bet_points.dart';
import 'quali_bet_points_mapper.dart';
import 'race_bet_points_mapper.dart';

@injectable
class SeasonGrandPrixBetPointsMapper {
  final QualiBetPointsMapper _qualiBetPointsMapper;
  final RaceBetPointsMapper _raceBetPointsMapper;

  const SeasonGrandPrixBetPointsMapper(
    this._qualiBetPointsMapper,
    this._raceBetPointsMapper,
  );

  SeasonGrandPrixBetPoints mapFromDto(
    SeasonGrandPrixBetPointsDto dto,
  ) => SeasonGrandPrixBetPoints(
    id: dto.id,
    playerId: dto.userId,
    season: dto.season,
    seasonGrandPrixId: dto.seasonGrandPrixId,
    totalPoints: dto.total,
    qualiBetPoints:
        dto.quali != null ? _qualiBetPointsMapper.mapFromDto(dto.quali!) : null,
    raceBetPoints:
        dto.race != null ? _raceBetPointsMapper.mapFromDto(dto.race!) : null,
  );
}
