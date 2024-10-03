import 'package:betgrid/data/firebase/model/race_bet_points_dto.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';

class RaceBetPointsCreator {
  final double totalPoints;
  final double p1Points;
  final double p2Points;
  final double p3Points;
  final double p10Points;
  final double fastestLapPoints;
  final double podiumAndP10Points;
  final double? podiumAndP10Multiplier;
  final double dnfPoints;
  final double dnfDriver1Points;
  final double dnfDriver2Points;
  final double dnfDriver3Points;
  final double? dnfMultiplier;
  final double safetyCarPoints;
  final double redFlagPoints;
  final double safetyCarAndRedFlagPoints;

  const RaceBetPointsCreator({
    this.totalPoints = 0,
    this.p1Points = 0,
    this.p2Points = 0,
    this.p3Points = 0,
    this.p10Points = 0,
    this.fastestLapPoints = 0,
    this.podiumAndP10Points = 0,
    this.podiumAndP10Multiplier,
    this.dnfPoints = 0,
    this.dnfDriver1Points = 0,
    this.dnfDriver2Points = 0,
    this.dnfDriver3Points = 0,
    this.dnfMultiplier,
    this.safetyCarPoints = 0,
    this.redFlagPoints = 0,
    this.safetyCarAndRedFlagPoints = 0,
  });

  RaceBetPoints createEntity() => RaceBetPoints(
        totalPoints: totalPoints,
        p1Points: p1Points,
        p2Points: p2Points,
        p3Points: p3Points,
        p10Points: p10Points,
        fastestLapPoints: fastestLapPoints,
        podiumAndP10Points: podiumAndP10Points,
        podiumAndP10Multiplier: podiumAndP10Multiplier,
        dnfPoints: dnfPoints,
        dnfDriver1Points: dnfDriver1Points,
        dnfDriver2Points: dnfDriver2Points,
        dnfDriver3Points: dnfDriver3Points,
        dnfMultiplier: dnfMultiplier,
        safetyCarPoints: safetyCarPoints,
        redFlagPoints: redFlagPoints,
        safetyCarAndRedFlagPoints: safetyCarAndRedFlagPoints,
      );

  RaceBetPointsDto createDto() => RaceBetPointsDto(
        totalPoints: totalPoints,
        p1Points: p1Points,
        p2Points: p2Points,
        p3Points: p3Points,
        p10Points: p10Points,
        fastestLapPoints: fastestLapPoints,
        podiumAndP10Points: podiumAndP10Points,
        podiumAndP10Multiplier: podiumAndP10Multiplier,
        dnfPoints: dnfPoints,
        dnfDriver1Points: dnfDriver1Points,
        dnfDriver2Points: dnfDriver2Points,
        dnfDriver3Points: dnfDriver3Points,
        dnfMultiplier: dnfMultiplier,
        safetyCarPoints: safetyCarPoints,
        redFlagPoints: redFlagPoints,
        safetyCarAndRedFlagPoints: safetyCarAndRedFlagPoints,
      );

  Map<String, Object?> createJson() => {
        'totalPoints': totalPoints,
        'p1Points': p1Points,
        'p2Points': p2Points,
        'p3Points': p3Points,
        'p10Points': p10Points,
        'fastestLapPoints': fastestLapPoints,
        'podiumAndP10Points': podiumAndP10Points,
        'podiumAndP10Multiplier': podiumAndP10Multiplier,
        'dnfPoints': dnfPoints,
        'dnfDriver1Points': dnfDriver1Points,
        'dnfDriver2Points': dnfDriver2Points,
        'dnfDriver3Points': dnfDriver3Points,
        'dnfMultiplier': dnfMultiplier,
        'safetyCarPoints': safetyCarPoints,
        'redFlagPoints': redFlagPoints,
        'safetyCarAndRedFlagPoints': safetyCarAndRedFlagPoints,
      };
}
