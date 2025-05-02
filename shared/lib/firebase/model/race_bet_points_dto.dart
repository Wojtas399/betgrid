class RaceBetPointsDto {
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

  const RaceBetPointsDto({
    required this.total,
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

  factory RaceBetPointsDto.fromFirestore({
    required Map<String, dynamic> json,
  }) =>
      RaceBetPointsDto(
        total: (json[RaceBetPointsFields.total] as num).toDouble(),
        p1: (json[RaceBetPointsFields.p1] as num).toDouble(),
        p2: (json[RaceBetPointsFields.p2] as num).toDouble(),
        p3: (json[RaceBetPointsFields.p3] as num).toDouble(),
        p10: (json[RaceBetPointsFields.p10] as num).toDouble(),
        fastestLap: (json[RaceBetPointsFields.fastestLap] as num).toDouble(),
        podiumAndP10:
            (json[RaceBetPointsFields.podiumAndP10] as num).toDouble(),
        podiumAndP10Multiplier:
            json[RaceBetPointsFields.podiumAndP10Multiplier] != null
                ? (json[RaceBetPointsFields.podiumAndP10Multiplier] as num)
                    .toDouble()
                : null,
        totalDnf: (json[RaceBetPointsFields.totalDnf] as num).toDouble(),
        dnfDriver1: (json[RaceBetPointsFields.dnfDriver1] as num).toDouble(),
        dnfDriver2: (json[RaceBetPointsFields.dnfDriver2] as num).toDouble(),
        dnfDriver3: (json[RaceBetPointsFields.dnfDriver3] as num).toDouble(),
        dnfMultiplier: json[RaceBetPointsFields.dnfMultiplier] != null
            ? (json[RaceBetPointsFields.dnfMultiplier] as num).toDouble()
            : null,
        safetyCar: (json[RaceBetPointsFields.safetyCar] as num).toDouble(),
        redFlag: (json[RaceBetPointsFields.redFlag] as num).toDouble(),
        safetyCarAndRedFlag:
            (json[RaceBetPointsFields.safetyCarAndRedFlag] as num).toDouble(),
      );

  Map<String, dynamic> toFirestore() => {
        RaceBetPointsFields.total: total,
        RaceBetPointsFields.p1: p1,
        RaceBetPointsFields.p2: p2,
        RaceBetPointsFields.p3: p3,
        RaceBetPointsFields.p10: p10,
        RaceBetPointsFields.fastestLap: fastestLap,
        RaceBetPointsFields.podiumAndP10: podiumAndP10,
        RaceBetPointsFields.podiumAndP10Multiplier: podiumAndP10Multiplier,
        RaceBetPointsFields.totalDnf: totalDnf,
        RaceBetPointsFields.dnfDriver1: dnfDriver1,
        RaceBetPointsFields.dnfDriver2: dnfDriver2,
        RaceBetPointsFields.dnfDriver3: dnfDriver3,
        RaceBetPointsFields.dnfMultiplier: dnfMultiplier,
        RaceBetPointsFields.safetyCar: safetyCar,
        RaceBetPointsFields.redFlag: redFlag,
        RaceBetPointsFields.safetyCarAndRedFlag: safetyCarAndRedFlag,
      };
}

class RaceBetPointsFields {
  static const total = 'total';
  static const p1 = 'p1';
  static const p2 = 'p2';
  static const p3 = 'p3';
  static const p10 = 'p10';
  static const fastestLap = 'fastestLap';
  static const podiumAndP10 = 'podiumAndP10';
  static const podiumAndP10Multiplier = 'podiumAndP10Multiplier';
  static const totalDnf = 'totalDnf';
  static const dnfDriver1 = 'dnfDriver1';
  static const dnfDriver2 = 'dnfDriver2';
  static const dnfDriver3 = 'dnfDriver3';
  static const dnfMultiplier = 'dnfMultiplier';
  static const safetyCar = 'safetyCar';
  static const redFlag = 'redFlag';
  static const safetyCarAndRedFlag = 'safetyCarAndRedFlag';
}
