class QualiBetPointsDto {
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

  const QualiBetPointsDto({
    required this.total,
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

  factory QualiBetPointsDto.fromFirestore({
    required Map<String, dynamic> json,
  }) =>
      QualiBetPointsDto(
        total: (json[QualiBetPointsFields.total] as num).toDouble(),
        q3P1: (json[QualiBetPointsFields.q3P1] as num).toDouble(),
        q3P2: (json[QualiBetPointsFields.q3P2] as num).toDouble(),
        q3P3: (json[QualiBetPointsFields.q3P3] as num).toDouble(),
        q3P4: (json[QualiBetPointsFields.q3P4] as num).toDouble(),
        q3P5: (json[QualiBetPointsFields.q3P5] as num).toDouble(),
        q3P6: (json[QualiBetPointsFields.q3P6] as num).toDouble(),
        q3P7: (json[QualiBetPointsFields.q3P7] as num).toDouble(),
        q3P8: (json[QualiBetPointsFields.q3P8] as num).toDouble(),
        q3P9: (json[QualiBetPointsFields.q3P9] as num).toDouble(),
        q3P10: (json[QualiBetPointsFields.q3P10] as num).toDouble(),
        q2P11: (json[QualiBetPointsFields.q2P11] as num).toDouble(),
        q2P12: (json[QualiBetPointsFields.q2P12] as num).toDouble(),
        q2P13: (json[QualiBetPointsFields.q2P13] as num).toDouble(),
        q2P14: (json[QualiBetPointsFields.q2P14] as num).toDouble(),
        q2P15: (json[QualiBetPointsFields.q2P15] as num).toDouble(),
        q1P16: (json[QualiBetPointsFields.q1P16] as num).toDouble(),
        q1P17: (json[QualiBetPointsFields.q1P17] as num).toDouble(),
        q1P18: (json[QualiBetPointsFields.q1P18] as num).toDouble(),
        q1P19: (json[QualiBetPointsFields.q1P19] as num).toDouble(),
        q1P20: (json[QualiBetPointsFields.q1P20] as num).toDouble(),
        totalQ1: (json[QualiBetPointsFields.totalQ1] as num).toDouble(),
        totalQ2: (json[QualiBetPointsFields.totalQ2] as num).toDouble(),
        totalQ3: (json[QualiBetPointsFields.totalQ3] as num).toDouble(),
        q1Multiplier: json[QualiBetPointsFields.q1Multiplier] != null
            ? (json[QualiBetPointsFields.q1Multiplier] as num).toDouble()
            : null,
        q2Multiplier: json[QualiBetPointsFields.q2Multiplier] != null
            ? (json[QualiBetPointsFields.q2Multiplier] as num).toDouble()
            : null,
        q3Multiplier: json[QualiBetPointsFields.q3Multiplier] != null
            ? (json[QualiBetPointsFields.q3Multiplier] as num).toDouble()
            : null,
        multiplier: json[QualiBetPointsFields.multiplier] != null
            ? (json[QualiBetPointsFields.multiplier] as num).toDouble()
            : null,
      );

  Map<String, dynamic> toFirestore() => {
        QualiBetPointsFields.total: total,
        QualiBetPointsFields.q3P1: q3P1,
        QualiBetPointsFields.q3P2: q3P2,
        QualiBetPointsFields.q3P3: q3P3,
        QualiBetPointsFields.q3P4: q3P4,
        QualiBetPointsFields.q3P5: q3P5,
        QualiBetPointsFields.q3P6: q3P6,
        QualiBetPointsFields.q3P7: q3P7,
        QualiBetPointsFields.q3P8: q3P8,
        QualiBetPointsFields.q3P9: q3P9,
        QualiBetPointsFields.q3P10: q3P10,
        QualiBetPointsFields.q2P11: q2P11,
        QualiBetPointsFields.q2P12: q2P12,
        QualiBetPointsFields.q2P13: q2P13,
        QualiBetPointsFields.q2P14: q2P14,
        QualiBetPointsFields.q2P15: q2P15,
        QualiBetPointsFields.q1P16: q1P16,
        QualiBetPointsFields.q1P17: q1P17,
        QualiBetPointsFields.q1P18: q1P18,
        QualiBetPointsFields.q1P19: q1P19,
        QualiBetPointsFields.q1P20: q1P20,
        QualiBetPointsFields.totalQ1: totalQ1,
        QualiBetPointsFields.totalQ2: totalQ2,
        QualiBetPointsFields.totalQ3: totalQ3,
        QualiBetPointsFields.q1Multiplier: q1Multiplier,
        QualiBetPointsFields.q2Multiplier: q2Multiplier,
        QualiBetPointsFields.q3Multiplier: q3Multiplier,
        QualiBetPointsFields.multiplier: multiplier,
      };
}

class QualiBetPointsFields {
  static const total = 'total';
  static const q3P1 = 'q3P1';
  static const q3P2 = 'q3P2';
  static const q3P3 = 'q3P3';
  static const q3P4 = 'q3P4';
  static const q3P5 = 'q3P5';
  static const q3P6 = 'q3P6';
  static const q3P7 = 'q3P7';
  static const q3P8 = 'q3P8';
  static const q3P9 = 'q3P9';
  static const q3P10 = 'q3P10';
  static const q2P11 = 'q2P11';
  static const q2P12 = 'q2P12';
  static const q2P13 = 'q2P13';
  static const q2P14 = 'q2P14';
  static const q2P15 = 'q2P15';
  static const q1P16 = 'q1P16';
  static const q1P17 = 'q1P17';
  static const q1P18 = 'q1P18';
  static const q1P19 = 'q1P19';
  static const q1P20 = 'q1P20';
  static const totalQ1 = 'totalQ1';
  static const totalQ2 = 'totalQ2';
  static const totalQ3 = 'totalQ3';
  static const q1Multiplier = 'q1Multiplier';
  static const q2Multiplier = 'q2Multiplier';
  static const q3Multiplier = 'q3Multiplier';
  static const multiplier = 'multiplier';
}
