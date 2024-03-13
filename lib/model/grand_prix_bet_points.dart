import 'package:equatable/equatable.dart';

import 'entity.dart';

class GrandPrixBetPoints extends Entity {
  final String playerId;
  final String grandPrixId;
  final double totalPoints;
  final QualiBetPoints? qualiBetPoints;
  final RaceBetPoints? raceBetPoints;

  const GrandPrixBetPoints({
    required super.id,
    required this.playerId,
    required this.grandPrixId,
    required this.totalPoints,
    this.qualiBetPoints,
    this.raceBetPoints,
  });

  @override
  List<Object?> get props => [
        id,
        playerId,
        grandPrixId,
        totalPoints,
        qualiBetPoints,
        raceBetPoints,
      ];
}

abstract class Points extends Equatable {
  final double totalPoints;

  const Points({required this.totalPoints});

  @override
  List<Object?> get props => [totalPoints];
}

class QualiBetPoints extends Points {
  final double q1P1Points;
  final double q1P2Points;
  final double q1P3Points;
  final double q1P4Points;
  final double q1P5Points;
  final double q1P6Points;
  final double q1P7Points;
  final double q1P8Points;
  final double q1P9Points;
  final double q1P10Points;
  final double q2P11Points;
  final double q2P12Points;
  final double q2P13Points;
  final double q2P14Points;
  final double q2P15Points;
  final double q3P16Points;
  final double q3P17Points;
  final double q3P18Points;
  final double q3P19Points;
  final double q3P20Points;
  final double q1Points;
  final double q2Points;
  final double q3Points;
  final double? q1Multiplier;
  final double? q2Multiplier;
  final double? q3Multiplier;
  final double? multiplier;

  const QualiBetPoints({
    required super.totalPoints,
    required this.q1P1Points,
    required this.q1P2Points,
    required this.q1P3Points,
    required this.q1P4Points,
    required this.q1P5Points,
    required this.q1P6Points,
    required this.q1P7Points,
    required this.q1P8Points,
    required this.q1P9Points,
    required this.q1P10Points,
    required this.q2P11Points,
    required this.q2P12Points,
    required this.q2P13Points,
    required this.q2P14Points,
    required this.q2P15Points,
    required this.q3P16Points,
    required this.q3P17Points,
    required this.q3P18Points,
    required this.q3P19Points,
    required this.q3P20Points,
    required this.q1Points,
    required this.q2Points,
    required this.q3Points,
    this.q1Multiplier,
    this.q2Multiplier,
    this.q3Multiplier,
    this.multiplier,
  });

  @override
  List<Object?> get props => [
        totalPoints,
        q1P1Points,
        q1P2Points,
        q1P3Points,
        q1P4Points,
        q1P5Points,
        q1P6Points,
        q1P7Points,
        q1P8Points,
        q1P9Points,
        q1P10Points,
        q2P11Points,
        q2P12Points,
        q2P13Points,
        q2P14Points,
        q2P15Points,
        q3P16Points,
        q3P17Points,
        q3P18Points,
        q3P19Points,
        q3P20Points,
        q1Points,
        q2Points,
        q3Points,
        q1Multiplier,
        q2Multiplier,
        q3Multiplier,
        multiplier,
      ];
}

class RaceBetPoints extends Points {
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

  const RaceBetPoints({
    required super.totalPoints,
    required this.p1Points,
    required this.p2Points,
    required this.p3Points,
    required this.p10Points,
    required this.fastestLapPoints,
    required this.podiumAndP10Points,
    this.podiumAndP10Multiplier,
    required this.dnfPoints,
    required this.dnfDriver1Points,
    required this.dnfDriver2Points,
    required this.dnfDriver3Points,
    this.dnfMultiplier,
    required this.safetyCarPoints,
    required this.redFlagPoints,
    required this.safetyCarAndRedFlagPoints,
  });

  @override
  List<Object?> get props => [
        totalPoints,
        p1Points,
        p2Points,
        p3Points,
        p10Points,
        fastestLapPoints,
        podiumAndP10Points,
        podiumAndP10Multiplier,
        dnfPoints,
        dnfDriver1Points,
        dnfDriver2Points,
        dnfDriver3Points,
        dnfMultiplier,
        safetyCarPoints,
        redFlagPoints,
        safetyCarAndRedFlagPoints
      ];
}
