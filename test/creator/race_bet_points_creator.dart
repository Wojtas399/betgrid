import 'package:betgrid/model/season_grand_prix_bet_points.dart';

class RaceBetPointsCreator {
  final double total;
  final double p1;
  final double p2;
  final double p3;
  final double p10;
  final double fastestLap;
  final double podiumAndP10;
  final double? podiumAndP10Multiplier;
  final double totalDnf;
  final double dnfDriver1;
  final double dnfDriver2;
  final double dnfDriver3;
  final double? dnfMultiplier;
  final double safetyCar;
  final double redFlag;
  final double safetyCarAndRedFlag;

  const RaceBetPointsCreator({
    this.total = 0,
    this.p1 = 0,
    this.p2 = 0,
    this.p3 = 0,
    this.p10 = 0,
    this.fastestLap = 0,
    this.podiumAndP10 = 0,
    this.podiumAndP10Multiplier,
    this.totalDnf = 0,
    this.dnfDriver1 = 0,
    this.dnfDriver2 = 0,
    this.dnfDriver3 = 0,
    this.dnfMultiplier,
    this.safetyCar = 0,
    this.redFlag = 0,
    this.safetyCarAndRedFlag = 0,
  });

  RaceBetPoints create() => RaceBetPoints(
        total: total,
        p1: p1,
        p2: p2,
        p3: p3,
        p10: p10,
        fastestLap: fastestLap,
        podiumAndP10: podiumAndP10,
        podiumAndP10Multiplier: podiumAndP10Multiplier,
        totalDnf: totalDnf,
        dnfDriver1: dnfDriver1,
        dnfDriver2: dnfDriver2,
        dnfDriver3: dnfDriver3,
        dnfMultiplier: dnfMultiplier,
        safetyCar: safetyCar,
        redFlag: redFlag,
        safetyCarAndRedFlag: safetyCarAndRedFlag,
      );
}
