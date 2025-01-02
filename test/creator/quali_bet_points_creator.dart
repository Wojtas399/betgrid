import 'package:betgrid/model/grand_prix_bet_points.dart';

class QualiBetPointsCreator {
  final double totalPoints;
  final double q3P1Points;
  final double q3P2Points;
  final double q3P3Points;
  final double q3P4Points;
  final double q3P5Points;
  final double q3P6Points;
  final double q3P7Points;
  final double q3P8Points;
  final double q3P9Points;
  final double q3P10Points;
  final double q2P11Points;
  final double q2P12Points;
  final double q2P13Points;
  final double q2P14Points;
  final double q2P15Points;
  final double q1P16Points;
  final double q1P17Points;
  final double q1P18Points;
  final double q1P19Points;
  final double q1P20Points;
  final double q1Points;
  final double q2Points;
  final double q3Points;
  final double? q1Multiplier;
  final double? q2Multiplier;
  final double? q3Multiplier;
  final double? multiplier;

  const QualiBetPointsCreator({
    this.totalPoints = 0.0,
    this.q3P1Points = 0.0,
    this.q3P2Points = 0.0,
    this.q3P3Points = 0.0,
    this.q3P4Points = 0.0,
    this.q3P5Points = 0.0,
    this.q3P6Points = 0.0,
    this.q3P7Points = 0.0,
    this.q3P8Points = 0.0,
    this.q3P9Points = 0.0,
    this.q3P10Points = 0.0,
    this.q2P11Points = 0.0,
    this.q2P12Points = 0.0,
    this.q2P13Points = 0.0,
    this.q2P14Points = 0.0,
    this.q2P15Points = 0.0,
    this.q1P16Points = 0.0,
    this.q1P17Points = 0.0,
    this.q1P18Points = 0.0,
    this.q1P19Points = 0.0,
    this.q1P20Points = 0.0,
    this.q1Points = 0.0,
    this.q2Points = 0.0,
    this.q3Points = 0.0,
    this.q1Multiplier,
    this.q2Multiplier,
    this.q3Multiplier,
    this.multiplier,
  });

  QualiBetPoints create() => QualiBetPoints(
        totalPoints: totalPoints,
        q3P1Points: q3P1Points,
        q3P2Points: q3P2Points,
        q3P3Points: q3P3Points,
        q3P4Points: q3P4Points,
        q3P5Points: q3P5Points,
        q3P6Points: q3P6Points,
        q3P7Points: q3P7Points,
        q3P8Points: q3P8Points,
        q3P9Points: q3P9Points,
        q3P10Points: q3P10Points,
        q2P11Points: q2P11Points,
        q2P12Points: q2P12Points,
        q2P13Points: q2P13Points,
        q2P14Points: q2P14Points,
        q2P15Points: q2P15Points,
        q1P16Points: q1P16Points,
        q1P17Points: q1P17Points,
        q1P18Points: q1P18Points,
        q1P19Points: q1P19Points,
        q1P20Points: q1P20Points,
        q1Points: q1Points,
        q2Points: q2Points,
        q3Points: q3Points,
        q1Multiplier: q1Multiplier,
        q2Multiplier: q2Multiplier,
        q3Multiplier: q3Multiplier,
        multiplier: multiplier,
      );
}
