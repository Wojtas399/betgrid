import '../../firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import '../../model/grand_prix_bet_points.dart';

RaceBetPoints mapRaceBetPointsFromDto(RaceBetPointsDto raceBetPointsDto) =>
    RaceBetPoints(
      totalPoints: raceBetPointsDto.totalPoints,
      p1Points: raceBetPointsDto.p1Points,
      p2Points: raceBetPointsDto.p2Points,
      p3Points: raceBetPointsDto.p3Points,
      p10Points: raceBetPointsDto.p10Points,
      fastestLapPoints: raceBetPointsDto.fastestLapPoints,
      podiumAndP10Multiplier: null,
      dnfPoints: raceBetPointsDto.dnfPoints,
      dnfMultiplier: raceBetPointsDto.dnfMultiplier,
      safetyCarPoints: raceBetPointsDto.safetyCarPoints,
      redFlagPoints: raceBetPointsDto.redFlagPoints,
    );
