import 'entity.dart';

class GrandPrixResult extends Entity {
  final String grandPrixId;
  final List<String>? qualiStandingsByDriverIds;
  final String? p1DriverId;
  final String? p2DriverId;
  final String? p3DriverId;
  final String? p10DriverId;
  final String? fastestLapDriverId;
  final List<String>? dnfDriverIds;
  final bool? wasThereSafetyCar;
  final bool? wasThereRedFlag;

  const GrandPrixResult({
    required super.id,
    required this.grandPrixId,
    this.qualiStandingsByDriverIds,
    this.p1DriverId,
    this.p2DriverId,
    this.p3DriverId,
    this.p10DriverId,
    this.fastestLapDriverId,
    this.dnfDriverIds,
    this.wasThereSafetyCar,
    this.wasThereRedFlag,
  });

  @override
  List<Object?> get props => [
        id,
        grandPrixId,
        qualiStandingsByDriverIds,
        p1DriverId,
        p2DriverId,
        p3DriverId,
        p10DriverId,
        fastestLapDriverId,
        dnfDriverIds,
        wasThereSafetyCar,
        wasThereRedFlag,
      ];
}
