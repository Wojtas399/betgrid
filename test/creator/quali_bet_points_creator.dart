import 'package:betgrid/model/season_grand_prix_bet_points.dart';

class QualiBetPointsCreator {
  final double total;
  final double q3P1;
  final double q3P2;
  final double q3P3;
  final double q3P4;
  final double q3P5;
  final double q3P6;
  final double q3P7;
  final double q3P8;
  final double q3P9;
  final double q3P10;
  final double q2P11;
  final double q2P12;
  final double q2P13;
  final double q2P14;
  final double q2P15;
  final double q1P16;
  final double q1P17;
  final double q1P18;
  final double q1P19;
  final double q1P20;
  final double totalQ1;
  final double totalQ2;
  final double totalQ3;
  final double? q1Multiplier;
  final double? q2Multiplier;
  final double? q3Multiplier;
  final double? multiplier;

  const QualiBetPointsCreator({
    this.total = 0.0,
    this.q3P1 = 0.0,
    this.q3P2 = 0.0,
    this.q3P3 = 0.0,
    this.q3P4 = 0.0,
    this.q3P5 = 0.0,
    this.q3P6 = 0.0,
    this.q3P7 = 0.0,
    this.q3P8 = 0.0,
    this.q3P9 = 0.0,
    this.q3P10 = 0.0,
    this.q2P11 = 0.0,
    this.q2P12 = 0.0,
    this.q2P13 = 0.0,
    this.q2P14 = 0.0,
    this.q2P15 = 0.0,
    this.q1P16 = 0.0,
    this.q1P17 = 0.0,
    this.q1P18 = 0.0,
    this.q1P19 = 0.0,
    this.q1P20 = 0.0,
    this.totalQ1 = 0.0,
    this.totalQ2 = 0.0,
    this.totalQ3 = 0.0,
    this.q1Multiplier,
    this.q2Multiplier,
    this.q3Multiplier,
    this.multiplier,
  });

  QualiBetPoints create() => QualiBetPoints(
    total: total,
    q3P1: q3P1,
    q3P2: q3P2,
    q3P3: q3P3,
    q3P4: q3P4,
    q3P5: q3P5,
    q3P6: q3P6,
    q3P7: q3P7,
    q3P8: q3P8,
    q3P9: q3P9,
    q3P10: q3P10,
    q2P11: q2P11,
    q2P12: q2P12,
    q2P13: q2P13,
    q2P14: q2P14,
    q2P15: q2P15,
    q1P16: q1P16,
    q1P17: q1P17,
    q1P18: q1P18,
    q1P19: q1P19,
    q1P20: q1P20,
    totalQ1: totalQ1,
    totalQ2: totalQ2,
    totalQ3: totalQ3,
    q1Multiplier: q1Multiplier,
    q2Multiplier: q2Multiplier,
    q3Multiplier: q3Multiplier,
    multiplier: multiplier,
  );
}
