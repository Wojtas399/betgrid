import 'package:equatable/equatable.dart';

import 'entity.dart';

class SeasonGrandPrixBetPoints extends Entity {
  final String playerId;
  final int season;
  final String seasonGrandPrixId;
  final double totalPoints;
  final QualiBetPoints? qualiBetPoints;
  final RaceBetPoints? raceBetPoints;

  const SeasonGrandPrixBetPoints({
    required super.id,
    required this.playerId,
    required this.season,
    required this.seasonGrandPrixId,
    required this.totalPoints,
    this.qualiBetPoints,
    this.raceBetPoints,
  });

  @override
  List<Object?> get props => [
    id,
    playerId,
    season,
    seasonGrandPrixId,
    totalPoints,
    qualiBetPoints,
    raceBetPoints,
  ];
}

abstract class Points extends Equatable {
  final double total;

  const Points({required this.total});

  @override
  List<Object?> get props => [total];
}

class QualiBetPoints extends Points {
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

  const QualiBetPoints({
    required super.total,
    required this.q3P1,
    required this.q3P2,
    required this.q3P3,
    required this.q3P4,
    required this.q3P5,
    required this.q3P6,
    required this.q3P7,
    required this.q3P8,
    required this.q3P9,
    required this.q3P10,
    required this.q2P11,
    required this.q2P12,
    required this.q2P13,
    required this.q2P14,
    required this.q2P15,
    required this.q1P16,
    required this.q1P17,
    required this.q1P18,
    required this.q1P19,
    required this.q1P20,
    required this.totalQ1,
    required this.totalQ2,
    required this.totalQ3,
    this.q1Multiplier,
    this.q2Multiplier,
    this.q3Multiplier,
    this.multiplier,
  });

  @override
  List<Object?> get props => [
    total,
    q3P1,
    q3P2,
    q3P3,
    q3P4,
    q3P5,
    q3P6,
    q3P7,
    q3P8,
    q3P9,
    q3P10,
    q2P11,
    q2P12,
    q2P13,
    q2P14,
    q2P15,
    q1P16,
    q1P17,
    q1P18,
    q1P19,
    q1P20,
    totalQ1,
    totalQ2,
    totalQ3,
    q1Multiplier,
    q2Multiplier,
    q3Multiplier,
    multiplier,
  ];
}

class RaceBetPoints extends Points {
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

  const RaceBetPoints({
    required super.total,
    required this.p1,
    required this.p2,
    required this.p3,
    required this.p10,
    required this.fastestLap,
    required this.podiumAndP10,
    this.podiumAndP10Multiplier,
    required this.totalDnf,
    required this.dnfDriver1,
    required this.dnfDriver2,
    required this.dnfDriver3,
    this.dnfMultiplier,
    required this.safetyCar,
    required this.redFlag,
    required this.safetyCarAndRedFlag,
  });

  @override
  List<Object?> get props => [
    total,
    p1,
    p2,
    p3,
    p10,
    fastestLap,
    podiumAndP10,
    podiumAndP10Multiplier,
    totalDnf,
    dnfDriver1,
    dnfDriver2,
    dnfDriver3,
    dnfMultiplier,
    safetyCar,
    redFlag,
    safetyCarAndRedFlag,
  ];
}
