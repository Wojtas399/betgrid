import 'package:equatable/equatable.dart';

import 'entity.dart';

class GrandPrixResults extends Entity {
  final String grandPrixId;
  final List<String?>? qualiStandingsByDriverIds;
  final RaceResults? raceResults;

  const GrandPrixResults({
    required super.id,
    required this.grandPrixId,
    this.qualiStandingsByDriverIds,
    this.raceResults,
  });

  @override
  List<Object?> get props => [
        id,
        grandPrixId,
        qualiStandingsByDriverIds,
        raceResults,
      ];
}

class RaceResults extends Equatable {
  final String p1DriverId;
  final String p2DriverId;
  final String p3DriverId;
  final String p10DriverId;
  final String fastestLapDriverId;
  final List<String> dnfDriverIds;
  final bool wasThereSafetyCar;
  final bool wasThereRedFlag;

  const RaceResults({
    required this.p1DriverId,
    required this.p2DriverId,
    required this.p3DriverId,
    required this.p10DriverId,
    required this.fastestLapDriverId,
    required this.dnfDriverIds,
    required this.wasThereSafetyCar,
    required this.wasThereRedFlag,
  });

  @override
  List<Object?> get props => [
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
