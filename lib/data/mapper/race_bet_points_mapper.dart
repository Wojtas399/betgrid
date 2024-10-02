import 'package:injectable/injectable.dart';

import '../../model/grand_prix_bet_points.dart';
import '../firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';

@injectable
class RaceBetPointsMapper {
  RaceBetPoints mapFromDto(RaceBetPointsDto raceBetPointsDto) => RaceBetPoints(
        totalPoints: raceBetPointsDto.totalPoints,
        p1Points: raceBetPointsDto.p1Points,
        p2Points: raceBetPointsDto.p2Points,
        p3Points: raceBetPointsDto.p3Points,
        p10Points: raceBetPointsDto.p10Points,
        fastestLapPoints: raceBetPointsDto.fastestLapPoints,
        podiumAndP10Points: raceBetPointsDto.podiumAndP10Points,
        podiumAndP10Multiplier: raceBetPointsDto.podiumAndP10Multiplier,
        dnfPoints: raceBetPointsDto.dnfPoints,
        dnfDriver1Points: raceBetPointsDto.dnfDriver1Points,
        dnfDriver2Points: raceBetPointsDto.dnfDriver2Points,
        dnfDriver3Points: raceBetPointsDto.dnfDriver3Points,
        dnfMultiplier: raceBetPointsDto.dnfMultiplier,
        safetyCarPoints: raceBetPointsDto.safetyCarPoints,
        redFlagPoints: raceBetPointsDto.redFlagPoints,
        safetyCarAndRedFlagPoints: raceBetPointsDto.safetyCarAndRedFlagPoints,
      );
}

RaceBetPoints mapRaceBetPointsFromDto(RaceBetPointsDto raceBetPointsDto) =>
    RaceBetPoints(
      totalPoints: raceBetPointsDto.totalPoints,
      p1Points: raceBetPointsDto.p1Points,
      p2Points: raceBetPointsDto.p2Points,
      p3Points: raceBetPointsDto.p3Points,
      p10Points: raceBetPointsDto.p10Points,
      fastestLapPoints: raceBetPointsDto.fastestLapPoints,
      podiumAndP10Points: raceBetPointsDto.podiumAndP10Points,
      podiumAndP10Multiplier: raceBetPointsDto.podiumAndP10Multiplier,
      dnfPoints: raceBetPointsDto.dnfPoints,
      dnfDriver1Points: raceBetPointsDto.dnfDriver1Points,
      dnfDriver2Points: raceBetPointsDto.dnfDriver2Points,
      dnfDriver3Points: raceBetPointsDto.dnfDriver3Points,
      dnfMultiplier: raceBetPointsDto.dnfMultiplier,
      safetyCarPoints: raceBetPointsDto.safetyCarPoints,
      redFlagPoints: raceBetPointsDto.redFlagPoints,
      safetyCarAndRedFlagPoints: raceBetPointsDto.safetyCarAndRedFlagPoints,
    );
