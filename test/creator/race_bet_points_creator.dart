import 'package:betgrid/model/grand_prix_bet_points.dart';

RaceBetPoints createRaceBetPoints({
  double totalPoints = 0.0,
  double p1Points = 0.0,
  double p2Points = 0.0,
  double p3Points = 0.0,
  double p10Points = 0.0,
  double fastestLapPoints = 0.0,
  double? podiumAndP10Multiplier,
  double dnfPoints = 0.0,
  double? dnfMultiplier,
  double safetyCarPoints = 0.0,
  double redFlagPoints = 0.0,
}) =>
    RaceBetPoints(
      totalPoints: totalPoints,
      p1Points: p1Points,
      p2Points: p2Points,
      p3Points: p3Points,
      p10Points: p10Points,
      fastestLapPoints: fastestLapPoints,
      podiumAndP10Multiplier: podiumAndP10Multiplier,
      dnfPoints: dnfPoints,
      dnfMultiplier: dnfMultiplier,
      safetyCarPoints: safetyCarPoints,
      redFlagPoints: redFlagPoints,
    );
