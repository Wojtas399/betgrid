import 'package:betgrid_shared/firebase/model/race_bet_points_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/grand_prix_bet_points.dart';

@injectable
class RaceBetPointsMapper {
  RaceBetPoints mapFromDto(RaceBetPointsDto raceBetPointsDto) => RaceBetPoints(
        totalPoints: raceBetPointsDto.total,
        p1Points: raceBetPointsDto.p1,
        p2Points: raceBetPointsDto.p2,
        p3Points: raceBetPointsDto.p3,
        p10Points: raceBetPointsDto.p10,
        fastestLapPoints: raceBetPointsDto.fastestLap,
        podiumAndP10Points: raceBetPointsDto.podiumAndP10,
        podiumAndP10Multiplier: raceBetPointsDto.podiumAndP10Multiplier,
        dnfPoints: raceBetPointsDto.totalDnf,
        dnfDriver1Points: raceBetPointsDto.dnfDriver1,
        dnfDriver2Points: raceBetPointsDto.dnfDriver2,
        dnfDriver3Points: raceBetPointsDto.dnfDriver3,
        dnfMultiplier: raceBetPointsDto.dnfMultiplier,
        safetyCarPoints: raceBetPointsDto.safetyCar,
        redFlagPoints: raceBetPointsDto.redFlag,
        safetyCarAndRedFlagPoints: raceBetPointsDto.safetyCarAndRedFlag,
      );
}
