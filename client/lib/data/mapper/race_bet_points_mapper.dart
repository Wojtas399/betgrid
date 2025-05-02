import 'package:betgrid_shared/firebase/model/race_bet_points_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/season_grand_prix_bet_points.dart';

@injectable
class RaceBetPointsMapper {
  RaceBetPoints mapFromDto(RaceBetPointsDto raceBetPointsDto) => RaceBetPoints(
    total: raceBetPointsDto.total,
    p1: raceBetPointsDto.p1,
    p2: raceBetPointsDto.p2,
    p3: raceBetPointsDto.p3,
    p10: raceBetPointsDto.p10,
    fastestLap: raceBetPointsDto.fastestLap,
    podiumAndP10: raceBetPointsDto.podiumAndP10,
    podiumAndP10Multiplier: raceBetPointsDto.podiumAndP10Multiplier,
    totalDnf: raceBetPointsDto.totalDnf,
    dnfDriver1: raceBetPointsDto.dnfDriver1,
    dnfDriver2: raceBetPointsDto.dnfDriver2,
    dnfDriver3: raceBetPointsDto.dnfDriver3,
    dnfMultiplier: raceBetPointsDto.dnfMultiplier,
    safetyCar: raceBetPointsDto.safetyCar,
    redFlag: raceBetPointsDto.redFlag,
    safetyCarAndRedFlag: raceBetPointsDto.safetyCarAndRedFlag,
  );
}
